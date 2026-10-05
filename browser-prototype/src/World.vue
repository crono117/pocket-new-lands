<script setup>
import { onMounted, onUnmounted, watch } from 'vue'
import { useLoop } from '@tresjs/core'
import * as T from 'three'
import { screenMotion, directionRow, allowedPosition, canTravel, frameColumn } from './simulation.js'
const props = defineProps(['state', 'move'])
const root = new T.Group(), home = new T.Group(), ash = new T.Group()
root.add(home, ash); ash.visible = false
const camera = new T.OrthographicCamera(-13,13,10,-10,.1,150)
camera.position.set(18,22,18); camera.lookAt(-1.5,0,1.5)
const ambient = new T.AmbientLight('#a6c4ef',2.1), sun = new T.DirectionalLight('#ffdcaa',3)
sun.position.set(-4,12,6); root.add(ambient,sun)
const materials = new Map(), actors = [], colliders = [], keys = new Set()
let target=null, clock=0, lastStatus='', active=true
const forward = new T.Vector3(-1,0,-1).normalize(), right = new T.Vector3(1,0,-1).normalize()
const textureLoader = new T.TextureLoader(), ray = new T.Raycaster(), groundPlane = new T.Plane(new T.Vector3(0,1,0),0)
const portals = []
function mat(color, emissive=0){const key=color+':'+emissive;if(!materials.has(key))materials.set(key,new T.MeshStandardMaterial({color,roughness:.85,metalness:.15,emissive:color,emissiveIntensity:emissive}));return materials.get(key)}
function box(group,x,y,z,w,h,d,color){const m=new T.Mesh(new T.BoxGeometry(w,h,d),mat(color));m.position.set(x,y,z);group.add(m);return m}
function cylinder(group,x,y,z,r,h,color,segments=8){const m=new T.Mesh(new T.CylinderGeometry(r,r,h,segments),mat(color));m.position.set(x,y,z);group.add(m);return m}
function platform(group,dark=false){
 cylinder(group,0,-1.3,0,7.4,1.9,dark?'#242a3c':'#353f48',8)
 cylinder(group,0,-2.5,0,5.9,.8,dark?'#171c2b':'#222b36',8)
 cylinder(group,0,-.4,0,7.65,.14,'#8c7050',8)
 for(let x=-6;x<=6;x++)for(let z=-6;z<=6;z++)if(Math.abs(x)+Math.abs(z)<10){
  box(group,x,-.17,z,.98,.3,.98,dark?(x*z%3?'#414754':'#4b505d'):((x+z)%3?'#667078':'#777e80'))
 }
}
platform(home);platform(ash,true)
// The chapel is an open colonnade: clear sightlines through ancient sacred machinery.
box(home,-1,.11,-3,4.8,.2,3.3,'#9b9586')
box(home,-1,.29,-2.2,3.6,.15,.6,'#b0a78e')
for(const x of [-3,1])for(const z of [-4.2,-1.8]){
 cylinder(home,x,1.5,z,.2,2.8,'#c6bba4',6);box(home,x,.25,z,.6,.35,.6,'#8d826e');box(home,x,2.98,z,.55,.3,.55,'#dccaaa')
}
box(home,-1,3.1,-4.2,4.8,.25,.45,'#c7b58e');box(home,-1,3.1,-1.8,4.8,.25,.45,'#c7b58e')
box(home,-1,.55,-3.4,1.35,.9,.9,'#696579')
const seed = new T.Mesh(new T.IcosahedronGeometry(.46,1),new T.MeshStandardMaterial({color:'#fff0b0',emissive:'#ffb83d',emissiveIntensity:3}));seed.position.set(-1,1.55,-3.4);home.add(seed)
const seedRing = new T.Mesh(new T.TorusGeometry(.75,.035,8,40),mat('#dbb77a',.6));seedRing.position.copy(seed.position);home.add(seedRing)
const hearthLight = new T.PointLight('#ffd28e',12,9); hearthLight.position.set(-1,2,-3.4); home.add(hearthLight)
for(let i=0;i<3;i++){
 box(home,-4.7,.2,1+i*1.2,1.5,.45,.95,'#726349');box(home,-4.7,.44,1+i*1.2,1.25,.08,.72,'#263e36')
 for(let j=0;j<3;j++){const plant=new T.Mesh(new T.IcosahedronGeometry(.22,0),mat(['#688d67','#779564','#527e72'][j]));plant.position.set(-5.05+j*.35,.68,1+i*1.2);home.add(plant)}
}
box(home,3.8,.52,3.4,2.0,.95,1.2,'#4e5c67');box(home,3.8,1.1,3.4,2.2,.18,1.4,'#967447')
for(let i=0;i<3;i++)cylinder(home,3.15+i*.6,1.33,3.4,.14,.35,'#c7a466')
box(home,4.7,.6,4.7,.9,1.2,.9,'#373d48');cylinder(home,4.7,1.6,4.7,.25,.9,'#806746')
colliders.push({x:3.8,z:3.4,w:2.5,d:1.8},{x:4.7,z:4.7,w:1.4,d:1.4},{x:-1,z:-3.4,w:1.8,d:1.4})
for(const [x,z] of [[-5,-4],[5,4],[-4,5],[5,-4]]){
 cylinder(home,x,.5,z,.2,1,'#8f8064');const flame=new T.Mesh(new T.OctahedronGeometry(.22),mat('#ffb452',3));flame.position.set(x,1.12,z);home.add(flame)
}
function portal(group,x,z,color){
 const ring=new T.Mesh(new T.TorusGeometry(1.1,.16,10,48),mat('#a18cba',.2));ring.position.set(x,1.35,z);ring.rotation.y=Math.PI/4;group.add(ring)
 const veil=new T.Mesh(new T.CircleGeometry(1.0,48),new T.MeshBasicMaterial({color,transparent:true,opacity:.55,side:T.DoubleSide,depthWrite:false}));veil.position.copy(ring.position);veil.rotation.copy(ring.rotation);group.add(veil)
 cylinder(group,x,.1,z,1.45,.2,'#67617a',12)
 const light=new T.PointLight(color,8,6);light.position.set(x,1.6,z);group.add(light)
 portals.push({ring,veil,x,z})
}
portal(home,4,-2,'#b18aff');portal(ash,-4,3,'#83e5dd')
// Ruined observatory, a second explorable pocket beyond the gate.
for(let i=0;i<8;i++){const a=i*Math.PI/4;cylinder(ash,Math.cos(a)*3,.5,Math.sin(a)*3-2,.25,.7+(i%3)*.6,'#666678')}
const lens = new T.Mesh(new T.TorusGeometry(1.65,.16,8,32),mat('#a99873'));lens.position.set(0,1,-2);lens.rotation.x=.8;ash.add(lens)
for(let i=0;i<12;i++)box(ash,Math.sin(i*2.4)*5,.15,Math.cos(i*2.4)*5,.35+(i%3)*.2,.3,.4,'#747381')
const starGeo=new T.BufferGeometry(),positions=[];let randomSeed=41
function random(){randomSeed=(Math.imul(randomSeed,1664525)+1013904223)>>>0;return randomSeed/4294967296}
for(let i=0;i<650;i++)positions.push((random()-.5)*100,(random()-.5)*60-5,(random()-.5)*100)
starGeo.setAttribute('position',new T.Float32BufferAttribute(positions,3));root.add(new T.Points(starGeo,new T.PointsMaterial({color:'#bdcde5',size:.08,transparent:true,opacity:.6})))
const sheetRows=['north','east','south','west']
function actor(id,x,z,controlled=false){
 const map=textureLoader.load(import.meta.env.BASE_URL+'sprites/'+id+'.png',undefined,undefined,()=>{props.state.status='A sprite failed to load. Reload or check the local asset copy.'});map.magFilter=T.NearestFilter;map.minFilter=T.NearestFilter;map.colorSpace=T.SRGBColorSpace;map.repeat.set(.25,.25)
 const sprite=new T.Sprite(new T.SpriteMaterial({map,transparent:true,alphaTest:.07,depthWrite:true}));sprite.center.set(.5,.07);sprite.position.set(x,.05,z);sprite.scale.set(1.65,1.65,1);home.add(sprite)
 const shadow=new T.Mesh(new T.CircleGeometry(.32,20),new T.MeshBasicMaterial({color:'#0c1524',transparent:true,opacity:.25,depthWrite:false}));shadow.rotation.x=-Math.PI/2;shadow.position.set(x,.014,z);home.add(shadow)
 const a={id,sprite,map,shadow,x,z,row:2,controlled,phase:random()*8,next:1+random()*3,dest:new T.Vector2(x,z),steam:[],arc:null,arcTimer:2+random()*5};actors.push(a);return a
}
const player=actor('robot',0,2,true)
actor('cyborg',-2,1);actor('ethereal',2,0);actor('plasma',3,2);actor('reptilian',-3,3);actor('archangel',0,-1);actor('anunnaki',1,3);actor('pilgrim',-1,4)
function allowed(x,z){return allowedPosition(x,z,props.state.realm,colliders)}
function travel(){if(props.state.paused){props.state.status='Resume time before crossing the gate.';return}const p=portals[props.state.realm==='hearth'?0:1];if(!canTravel(player.x,player.z,p)){props.state.status='Walk closer to the glowing gate first.';return}props.state.realm=props.state.realm==='hearth'?'ash':'hearth';home.visible=props.state.realm==='hearth';ash.visible=!home.visible;home.remove(player.sprite,player.shadow);(home.visible?home:ash).add(player.sprite,player.shadow);player.x=home.visible?2.2:-2.3;player.z=home.visible?-1:3;target=null;props.state.status=home.visible?'You returned safely to the Hearth.':'The gate opens onto a ruined observatory. Explore, then return through the cyan gate.'}
function reset(){player.x=props.state.realm==='hearth'?0:-2.3;player.z=props.state.realm==='hearth'?2:3;target=null;keys.clear();props.move.x=props.move.y=0}
defineExpose({travel,reset})
function keydown(e){if(['INPUT','BUTTON'].includes(e.target.tagName))return;const k=e.key.toLowerCase();if(['arrowup','arrowdown','arrowleft','arrowright',' '].includes(k))e.preventDefault();if(e.repeat&&[' ','e'].includes(k))return;keys.add(k);if(k==='e')travel();if(k===' ')props.state.paused=!props.state.paused}
function keyup(e){keys.delete(e.key.toLowerCase())}
function blur(){keys.clear();props.move.x=props.move.y=0}
function pointer(e){if(e.target.tagName!=='CANVAS')return;const bounds=e.target.getBoundingClientRect();ray.setFromCamera(new T.Vector2((e.clientX-bounds.left)/bounds.width*2-1,-(e.clientY-bounds.top)/bounds.height*2+1),camera);const hit=new T.Vector3();if(ray.ray.intersectPlane(groundPlane,hit)&&allowed(hit.x,hit.z))target=new T.Vector2(hit.x,hit.z)}
onMounted(()=>{window.addEventListener('keydown',keydown);window.addEventListener('keyup',keyup);window.addEventListener('blur',blur);window.addEventListener('pointerdown',pointer)})
onUnmounted(()=>{active=false;window.removeEventListener('keydown',keydown);window.removeEventListener('keyup',keyup);window.removeEventListener('blur',blur);window.removeEventListener('pointerdown',pointer);root.traverse(o=>{o.geometry?.dispose();if(o.material&&!materials.has(o.material)){o.material.map?.dispose();o.material.dispose()}});for(const m of materials.values())m.dispose()})
watch(()=>props.state.realm,()=>target=null)
function effects(a,dt){
 const group=a.sprite.parent
 for(const puff of a.steam) if(puff.mesh.parent!==group) group.add(puff.mesh)
 if(a.arc && a.arc.parent!==group) group.add(a.arc)
 if(!props.state.effects){for(const p of a.steam){p.mesh.parent?.remove(p.mesh);p.mesh.geometry.dispose();p.mesh.material.dispose()}a.steam=[];if(a.arc){a.arc.parent?.remove(a.arc);a.arc.geometry.dispose();a.arc.material.dispose();a.arc=null}return}
 if(a.id==='robot'){a.next-=dt;if(a.next<0){a.next=1.3+random()*2;const m=new T.Sprite(new T.SpriteMaterial({color:'#d1e2e9',transparent:true,opacity:.22,depthWrite:false}));m.position.set(a.x-.18,.85,a.z);m.scale.setScalar(.13);group.add(m);a.steam.push({mesh:m,life:0})}}
 for(const p of a.steam){p.life+=dt;p.mesh.position.y+=dt*.45;p.mesh.position.x+=dt*.07;p.mesh.scale.setScalar(.13+p.life*.18);p.mesh.material.opacity=.2*(1-p.life/1.4)}
 a.steam=a.steam.filter(p=>{if(p.life<1.4)return true;p.mesh.parent?.remove(p.mesh);p.mesh.material.dispose();return false})
 if(['robot','cyborg','plasma'].includes(a.id)){a.arcTimer-=dt;if(a.arcTimer<0){a.arcTimer=2.5+random()*4;const pts=[];for(let i=0;i<6;i++)pts.push(new T.Vector3(a.x-.3+i*.1,.6+random()*.16,a.z+.15));a.arc=new T.Line(new T.BufferGeometry().setFromPoints(pts),new T.LineBasicMaterial({color:'#8fefff',transparent:true,opacity:.85}));a.arc.userData.life=.16;group.add(a.arc)}if(a.arc){a.arc.userData.life-=dt;if(a.arc.userData.life<=0){a.arc.parent?.remove(a.arc);a.arc.geometry.dispose();a.arc.material.dispose();a.arc=null}}}
}
useLoop().onBeforeRender(({delta,elapsed,sizes})=>{
 if(!active)return
 const aspect=sizes.width.value/sizes.height.value;const half=10/props.state.zoom;camera.left=-half*aspect;camera.right=half*aspect;camera.top=half;camera.bottom=-half;camera.updateProjectionMatrix()
 if(props.state.paused)return
 const dt=Math.min(delta,.05);clock+=dt
 seed.rotation.y+=dt*.3;seed.position.y=1.55+Math.sin(clock*1.5)*.06;seedRing.rotation.y+=dt*.16
 portals.forEach(p=>{p.veil.material.opacity=.45+Math.sin(clock*2)*.12;p.ring.material.emissiveIntensity=props.state.effects?.2+Math.sin(clock*2)*.1:0})
 for(const a of actors){
  if(!a.controlled&&props.state.realm!=='hearth')continue
  let vx=0,vz=0
  if(a.controlled){const sx=Number(keys.has('d')||keys.has('arrowright'))-Number(keys.has('a')||keys.has('arrowleft'))+props.move.x;const sy=Number(keys.has('s')||keys.has('arrowdown'))-Number(keys.has('w')||keys.has('arrowup'))+props.move.y;if(sx||sy){target=null;const m=screenMotion(sx,sy);vx=m.x;vz=m.z}else if(target){vx=target.x-a.x;vz=target.y-a.z;if(Math.hypot(vx,vz)<.12){target=null;vx=vz=0}}}
  else {a.phase-=dt;if(a.phase<=0){a.phase=3+random()*5;a.dest.set(Math.max(-5,Math.min(5,a.x+(random()-.5)*4)),Math.max(-5,Math.min(5,a.z+(random()-.5)*4)))}vx=a.dest.x-a.x;vz=a.dest.y-a.z;if(Math.hypot(vx,vz)<.12)vx=vz=0}
  const len=Math.hypot(vx,vz),moving=len>.01,speed=a.controlled?2.4:.55
  if(moving){vx/=len;vz/=len;const x=a.x+vx*dt*speed,z=a.z+vz*dt*speed;if(allowed(x,a.z))a.x=x;if(allowed(a.x,z))a.z=z;a.row=directionRow(vx,vz)}
  let col=moving?Math.floor(clock*6)%4:1;col=frameColumn(a.id,a.row,col);a.map.offset.set(col*.25,(3-a.row)*.25)
  a.sprite.position.set(a.x,.05,a.z);const pulse=props.state.effects?Math.sin(clock*1.65+actors.indexOf(a))*.012:0;a.sprite.scale.set(1.65*(1-pulse*.4),1.65*(1+pulse),1);a.shadow.position.set(a.x,.014,a.z);effects(a,dt)
 }
 const gate=portals[props.state.realm==='hearth'?0:1];const nearby=canTravel(player.x,player.z,gate)
 const status=nearby?'The gate answers your presence. Press E to cross.':props.state.realm==='hearth'?'Walk among the residents, then approach the violet gate.':'Explore the ruins. The cyan gate leads home.'
 if(status!==lastStatus){props.state.status=status;lastStatus=status}
})
</script>
<template><primitive :object="camera" /><primitive :object="root" /></template>
