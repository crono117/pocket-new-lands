export function screenMotion(x,y){const s=Math.SQRT1_2;return {x:(x+y)*s,z:(-x+y)*s}}
export function directionRow(x,z){const screenX=(x-z)*Math.SQRT1_2,screenUp=-(x+z)*Math.SQRT1_2;return Math.abs(screenX)>Math.abs(screenUp)?(screenX>0?1:3):(screenUp>0?0:2)}
export function allowedPosition(x,z,realm,colliders=[]){if(Math.abs(x)>6||Math.abs(z)>6||Math.abs(x)+Math.abs(z)>8.8)return false;if(realm==='ash')return true;return !colliders.some(c=>Math.abs(x-c.x)<c.w/2+.25&&Math.abs(z-c.z)<c.d/2+.25)}
export function canTravel(x,z,gate){return Math.hypot(x-gate.x,z-gate.z)<=2}
export function frameColumn(id,row,col){if(id==='cyborg'&&row===0&&col===3)return 1;if(id==='anunnaki'){if(row===0&&col===1)return 3;if(row===2&&col===0)return 1}if(id==='pilgrim'){if(row===0)return [0,1,0,1][col];if(row===2)return [2,3,2,3][col]}return col}
