import * as T from 'three'
export const RETREAT=Object.freeze({x:0,z:4.4,w:2.7,d:2.3})
export function createWizardsRetreat(){
 const g=new T.Group();g.name='WizardsRetreat';g.position.set(0,0,4.4)
 const cache=new Map(),mat=(c,e=0)=>{const k=c+e;if(!cache.has(k))cache.set(k,new T.MeshStandardMaterial({color:c,emissive:c,emissiveIntensity:e,roughness:.85,metalness:.12}));return cache.get(k)}
 const mesh=(geo,c,x,y,z,e=0)=>{const m=new T.Mesh(geo,mat(c,e));m.position.set(x,y,z);g.add(m);return m}
 const box=(x,y,z,w,h,d,c)=>mesh(new T.BoxGeometry(w,h,d),c,x,y,z)
 const rod=(a,b,r,c)=>{const d=new T.Vector3().subVectors(b,a),m=mesh(new T.CylinderGeometry(r,r,d.length(),7),c,0,0,0);m.position.copy(a).add(b).multiplyScalar(.5);m.quaternion.setFromUnitVectors(new T.Vector3(0,1,0),d.normalize());return m}
 const ring=(x,y,z,r,c)=>mesh(new T.TorusGeometry(r,.025,6,32),c,x,y,z)
 // Round aubergine masonry and crooked copper roof replace the domestic gable.
 mesh(new T.CylinderGeometry(1.16,1.35,.3,11),'#777081',0,.15,0)
 mesh(new T.CylinderGeometry(1.07,1.2,1.65,11),'#51465e',0,1.03,0)
 for(let j=0;j<5;j++)for(let i=0;i<11;i++){const a=(i+j%2*.5)*Math.PI*2/11,r=1.18-j*.024;const b=box(Math.sin(a)*r,.42+j*.29,Math.cos(a)*r,.57,.255,.13,j%3?'#655771':'#807286');b.rotation.y=a}
 const profile=[[1.65,1.8],[1.48,1.98],[1.13,2.25],[.85,2.62],[.6,3.02],[.38,3.4],[.19,3.74],[.025,4.08]]
 const roof=mesh(new T.LatheGeometry(profile.map(([r,y])=>new T.Vector2(r,y)),20),'#224f58',0,0,0);roof.rotation.z=-.085
 for(let j=0;j<profile.length-1;j++){const [r,y]=profile[j],shift=(y-1.8)*.085;const t=ring(shift,y,0,r,'#719c91');t.rotation.x=Math.PI/2;for(let i=0;i<20;i++){const a=(i+j%2*.5)*Math.PI/10,m=mesh(new T.SphereGeometry(1,6,4),i%4?'#32656b':'#568780',Math.sin(a)*r+shift,y+.045,Math.cos(a)*r);m.scale.set(.17,.055,.23);m.rotation.y=a}}
 const crescent=mesh(new T.TorusGeometry(.21,.045,6,24,Math.PI*1.5),'#c4a276',.34,4.24,0);crescent.rotation.z=-.5
 rod(new T.Vector3(.31,3.9,0),new T.Vector3(.34,4.15,0),.025,'#c4a276')
 rod(new T.Vector3(-.8,1.8,-.45),new T.Vector3(-1.08,2.92,-.45),.16,'#51465e');rod(new T.Vector3(-1.08,2.92,-.45),new T.Vector3(-.87,3.22,-.45),.14,'#796a83')
 box(0,.88,1.2,.7,1.35,.12,'#302c43')
 for(const side of [-1,1]){rod(new T.Vector3(side*.42,.23,1.25),new T.Vector3(side*.32,1.52,1.25),.055,'#c4a276');rod(new T.Vector3(side*.32,1.52,1.25),new T.Vector3(0,1.83,1.25),.055,'#c4a276')}
 for(let i=0;i<5;i++){const r=box(-.23+i*.115,1.47+Math.sin(i)*.06,1.29,.045,.075,.025,'#96d6c4');r.rotation.z=.7}
 box(0,.13,1.49,1.02,.24,.55,'#8c8297');box(0,.05,1.85,1.22,.1,.28,'#736a80')
 const mirror=mesh(new T.CircleGeometry(.3,32),'#85cbbd',-.72,1.23,.96,.75);mirror.rotation.y=-.62
 const frame=ring(-.73,1.23,.97,.34,'#c4a276');frame.rotation.y=-.62
 const lights=[]
 for(const [x,z,y] of [[.71,1.04,1.36],[-1.35,.35,1.65],[1.37,-.12,1.9]]){rod(new T.Vector3(x,y+.25,z),new T.Vector3(x,y+.04,z),.012,'#c4a276');lights.push(mesh(new T.OctahedronGeometry(.1),'#a4eadb',x,y,z,1.1))}
 const light=new T.PointLight('#a6e4d3',2,3.5);light.position.set(.3,1.1,1.5);g.add(light)
 for(let v=0;v<8;v++){const a=v*Math.PI/4,r=1.23;let prev=new T.Vector3(Math.sin(a)*r,1.92,Math.cos(a)*r);for(let i=1;i<9;i++){const angle=a+Math.sin(i*.8+v)*.08,p=new T.Vector3(Math.sin(angle)*r,1.92-i*.19,Math.cos(angle)*r);if(Math.abs(p.x)<.46&&p.z>.9)continue;rod(prev,p,.018,'#537c78');prev=p;const l=mesh(new T.OctahedronGeometry(.12),i%3?'#658e89':'#a59bb9',p.x+.06,p.y,p.z);l.scale.set(.6,1,.35);l.rotation.z=.6}}
 for(let i=0;i<8;i++){const a=2+i*.53,x=Math.sin(a)*1.42,z=Math.cos(a)*1.42;rod(new T.Vector3(x,.03,z),new T.Vector3(x,.18,z),.025,'#b4a3bd');const cap=mesh(new T.SphereGeometry(.12,8,4),'#8abfb3',x,.2,z);cap.scale.y=.35}
 box(1.48,.55,.65,.62,.12,.5,'#302c43');for(const x of [1.25,1.7])box(x,.27,.65,.05,.5,.05,'#302c43');box(1.45,.64,.65,.27,.06,.22,'#c6b5b1')
 for(let i=0;i<3;i++)mesh(new T.SphereGeometry(.065,8,6),['#b695d2','#8ee0ce','#dda781'][i],1.28+i*.16,.72,.55,.2)
 let trunk=new T.Vector3(-1.65,0,-.4)
 for(let i=1;i<=10;i++){const p=new T.Vector3(-1.65-i*.035,i*.35,-.4);rod(trunk,p,.08-i*.002,'#74657b');trunk=p}
 for(let i=0;i<9;i++){const a=i*Math.PI*2/9;let prev=trunk.clone();for(let j=1;j<5;j++){const p=new T.Vector3(trunk.x+Math.cos(a)*j*.3,trunk.y+.3-j*j*.035,trunk.z+Math.sin(a)*j*.3);rod(prev,p,.022,'#537c78');const l=mesh(new T.OctahedronGeometry(.23),'#6b9990',p.x,p.y,p.z);l.scale.set(.45,1.6,.2);l.rotation.z=Math.PI/2;l.rotation.y=-a;prev=p}}
 g.userData.animate=(t,e)=>{mirror.material.emissiveIntensity=e?.65+Math.sin(t*.7)*.15:.5;for(const l of lights)l.material.emissiveIntensity=e?1+Math.sin(t*1.4)*.15:.8}
 return g
}
