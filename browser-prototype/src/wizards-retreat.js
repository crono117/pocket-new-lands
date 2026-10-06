import * as T from 'three'

// Original refuge inspired by the mood of Wolfe's Jungle Garden, not a literal book reconstruction.
export const RETREAT = Object.freeze({ x: 0, z: 4.4, w: 2.7, d: 2.3 })

export function createWizardsRetreat() {
 const group = new T.Group(); group.name = 'WizardsRetreat'; group.position.set(RETREAT.x, 0, RETREAT.z)
 const materials = new Map()
 function material(color, emission=0) { const key=color+':'+emission; if(!materials.has(key)) materials.set(key,new T.MeshStandardMaterial({color,roughness:.9,metalness:.04,emissive:color,emissiveIntensity:emission})); return materials.get(key) }
 function block(x,y,z,w,h,d,color) { const mesh=new T.Mesh(new T.BoxGeometry(w,h,d),material(color));mesh.position.set(x,y,z);group.add(mesh);return mesh }
 function rod(a,b,r,color) {const delta=new T.Vector3().subVectors(b,a);const mesh=new T.Mesh(new T.CylinderGeometry(r,r,delta.length(),6),material(color));mesh.position.copy(a).add(b).multiplyScalar(.5);mesh.quaternion.setFromUnitVectors(new T.Vector3(0,1,0),delta.normalize());group.add(mesh);return mesh}
 function leaf(x,y,z,size,color,rotation=0) {const mesh=new T.Mesh(new T.OctahedronGeometry(size,0),material(color));mesh.scale.set(.55,1.2,.35);mesh.position.set(x,y,z);mesh.rotation.z=rotation;group.add(mesh);return mesh}
 block(0,.15,0,2.8,.3,2.4,'#706e66')
 block(0,1.03,0,2.6,1.65,2.1,'#ac9780')
 // Uneven stone footing, exposed timber and plank siding.
 for(let i=0;i<7;i++)block(-1.14+i*.38,.35,1.075,.35,.22,.13,i%2?'#848174':'#686e6a')
 for(const x of [-1.28,1.28])for(const z of [-1.04,1.04])block(x,1.0,z,.12,1.6,.12,'#564c43')
 for(let y=.65;y<1.85;y+=.22){block(0,y,1.065,2.6,.035,.025,'#8b775f');block(-1.31,y,0,.025,.035,2.08,'#8b775f')}
 block(0,1.83,1.06,2.75,.15,.15,'#655549')
 // Gabled roof with generous eaves, hand-sized courses and a bronze ridge.
 const roofShape=new T.Shape();roofShape.moveTo(-1.6,0);roofShape.lineTo(1.6,0);roofShape.lineTo(0,1.0);roofShape.closePath()
 const roof=new T.Mesh(new T.ExtrudeGeometry(roofShape,{depth:2.7,bevelEnabled:false}),material('#474f59'));roof.position.set(0,1.88,-1.35);group.add(roof)
 for(let i=0;i<5;i++){
  const y=1.94+i*.18,span=1.5-i*.28
  for(const side of [-1,1]){const trim=block(side*span,y,0,.07,.05,2.78,i%2?'#69716e':'#5b6265');trim.rotation.z=side>0?-.56:.56}
 }
 block(0,2.89,0,.1,.09,2.78,'#b49a69')
 // Door, arched windows, shutters, and a small covered stoop.
 block(0,.84,1.091,.61,1.25,.07,'#313a3e')
 for(let i=0;i<5;i++)block(-.24+i*.12,.84,1.14,.095,1.18,.035,'#655e50')
 rod(new T.Vector3(-.36,.23,1.13),new T.Vector3(-.36,1.5,1.13),.055,'#b39a70')
 rod(new T.Vector3(.36,.23,1.13),new T.Vector3(.36,1.5,1.13),.055,'#b39a70')
 block(0,1.51,1.13,.82,.09,.12,'#b39a70')
 const knob=new T.Mesh(new T.SphereGeometry(.043,8,6),material('#cfa35a'));knob.position.set(.22,.84,1.19);group.add(knob)
 function windowAt(x) {
  const shape=new T.Shape();shape.moveTo(-.22,-.26);shape.lineTo(.22,-.26);shape.lineTo(.22,.1);shape.absarc(0,.1,.22,0,Math.PI,false);shape.lineTo(-.22,-.26)
  const glass=new T.Mesh(new T.ShapeGeometry(shape),material('#f9c47a',.8));glass.position.set(x,1.14,1.12);group.add(glass)
  block(x,.88,1.17,.6,.08,.22,'#635e4f');block(x,1.16,1.14,.035,.55,.035,'#68564a');block(x,1.15,1.14,.43,.035,.035,'#68564a')
  for(const side of [-1,1]){const shutter=block(x+side*.33,1.15,1.115,.14,.57,.05,'#4f7068');shutter.rotation.y=side*.28}
 }
 windowAt(-.84);windowAt(.84)
 block(0,.12,1.42,1.1,.22,.7,'#97917c');block(0,.05,1.84,1.3,.1,.32,'#85857a')
 // Old technology tucked into ordinary domestic objects.
 const mirror=new T.Mesh(new T.CircleGeometry(.25,24),new T.MeshStandardMaterial({color:'#8ad5d5',emissive:'#75a2d4',emissiveIntensity:.55,metalness:.65,roughness:.2}));mirror.rotation.y=Math.PI/2;mirror.position.set(1.32,1.22,.18);group.add(mirror)
 const mirrorFrame=new T.Mesh(new T.TorusGeometry(.28,.025,6,24),material('#af956e'));mirrorFrame.rotation.y=Math.PI/2;mirrorFrame.position.copy(mirror.position);group.add(mirrorFrame)
 block(-.7,2.47,-.62,.36,1.0,.36,'#777365');block(-.7,3,-.62,.49,.1,.49,'#b4a48b')
 const lantern=new T.Mesh(new T.OctahedronGeometry(.09),material('#ffd58c',1));lantern.position.set(.44,1.36,1.28);group.add(lantern)
 const light=new T.PointLight('#ffd49c',3,4);light.position.set(0,1.0,1.8);group.add(light)
 // Trailing vine stems and individual leaves; never a flat decorative overlay.
 for(let vine=0;vine<4;vine++){
  const base=-1.2+vine*.78
  let previous=new T.Vector3(base,1.85,1.19)
  for(let i=1;i<8;i++){
   const x=base+Math.sin(i*1.3+vine)*.13,y=1.85-i*.18,z=1.19+Math.sin(i)*.04
   const next=new T.Vector3(x,y,z);rod(previous,next,.015,'#37574a');leaf(x+.065,y,z,.09,i%2?'#69825a':'#476b56',.6);previous=next
  }
 }
 // Tall palm beside the refuge, leaning slightly away from the doorway.
 const palmX=-1.75,palmZ=-.45
 let trunk=new T.Vector3(palmX,.05,palmZ)
 for(let i=1;i<=10;i++){const next=new T.Vector3(palmX-i*.014,i*.35,palmZ-i*.015);rod(trunk,next,.085-i*.002,'#8c7353');trunk=next}
 for(let i=0;i<8;i++){
  const angle=i*Math.PI/4
  let last=trunk.clone()
  for(let j=1;j<=4;j++){
   const reach=j*.33;const point=new T.Vector3(trunk.x+Math.cos(angle)*reach,trunk.y+.24-j*j*.035,trunk.z+Math.sin(angle)*reach)
   rod(last,point,.028,'#4c7256')
   const blade=leaf(point.x,point.y,point.z,.22,'#54795c',Math.PI/2);blade.rotation.y=-angle;last=point
  }
 }
 // Small outdoor reading desk and herb vessels.
 block(1.55,.62,.95,.65,.12,.55,'#81745b');for(const x of [1.32,1.78])block(x,.32,.95,.06,.55,.07,'#675c4c')
 block(1.5,.71,.94,.28,.07,.24,'#e0cda2')
 for(const [x,z] of [[-1.5,1.2],[1.45,-.75]]){const pot=new T.Mesh(new T.CylinderGeometry(.15,.1,.25,8),material('#876151'));pot.position.set(x,.14,z);group.add(pot);for(let i=0;i<3;i++)leaf(x+(i-1)*.065,.4,z,.12,'#719361',i*.4)}
 group.userData.animate=(time,effects)=>{mirror.material.emissiveIntensity=effects?.48+Math.sin(time*.7)*.12:.35;lantern.material.emissiveIntensity=effects?.85+Math.sin(time*1.8)*.1:.7}
 return group
}
