import * as T from 'three'
export function marbleWear(x,z){return Math.max(0,Math.min(1,.5+.23*Math.sin(x*.42+z*.18)+.19*Math.cos(z*.52-x*.12)+.08*Math.sin(x*.9-z*.7)))}
export function createMarbleFloor(){
 const g=new T.Group();g.name='WornMarbleFloor'
 const size=512,data=new Uint8Array(size*size*4)
 for(let y=0;y<size;y++)for(let x=0;x<size;x++){
  const wx=x/(size-1)*13-6.5,wz=y/(size-1)*13-6.5,w=marbleWear(wx,wz)
  const wave=wx*.8+wz*.48+.2*Math.sin(wz*2.1)+.09*Math.sin(wx*4+wz)
  const vein=Math.pow(Math.max(0,1-Math.abs(Math.sin(wave*9))*9),2),grain=(Math.sin(x*127.1+y*311.7)*43758.5453)%1
  const path=Math.abs(Math.sin(wx*1.7+wz*.8+.14*Math.sin(wz*12)))
  // Damage fades in through dusty weathered areas, never abruptly beside pristine stone.
  const crack=Math.max(0,Math.min(1,(w-.6)/.18))*Math.max(0,1-path/.018)*55,dust=Math.max(0,w-.4)*35,k=(y*size+x)*4
  data[k]=190-vein*30-dust-crack+grain*3;data[k+1]=190-vein*24-dust*1.15-crack+grain*3;data[k+2]=198-vein*17-dust*1.35-crack+grain*3;data[k+3]=255
 }
 const atlas=new T.DataTexture(data,size,size);atlas.colorSpace=T.SRGBColorSpace;atlas.needsUpdate=true
 // Each top face samples its world-space atlas rectangle; veins connect across grout.
 for(let x=-6;x<=6;x++)for(let z=-6;z<=6;z++)if(Math.abs(x)+Math.abs(z)<10){
  const wear=marbleWear(x,z),geo=new T.BoxGeometry(.975,.3,.975),uv=geo.attributes.uv,pos=geo.attributes.position
  for(let i=0;i<pos.count;i++)uv.setXY(i,(x+pos.getX(i)+6.5)/13,(z+pos.getZ(i)+6.5)/13)
  const m=new T.MeshStandardMaterial({map:atlas,color:new T.Color().setHSL(.68,.035,.97-wear*.08),roughness:.23+wear*.65,metalness:.04})
  const tile=new T.Mesh(geo,m);tile.position.set(x,-.17,z);g.add(tile)
 }
 return g
}
