const GAMEPLAY_KEYS=new Set(['arrowup','arrowdown','arrowleft','arrowright','w','a','s','d','e',' '])
export function acceptsGameplayKey(tagName,key){const tag=String(tagName||'').toUpperCase(),k=String(key||'').toLowerCase();if(tag==='INPUT'||tag==='TEXTAREA'||tag==='SELECT')return false;if(tag==='BUTTON')return GAMEPLAY_KEYS.has(k);return true}
export function screenMotion(x,y){const s=Math.SQRT1_2;return {x:(x+y)*s,z:(-x+y)*s}}
export function directionRow(x,z){const screenX=(x-z)*Math.SQRT1_2,screenUp=-(x+z)*Math.SQRT1_2;return Math.abs(screenX)>Math.abs(screenUp)?(screenX>0?1:3):(screenUp>0?0:2)}
export function allowedPosition(x,z,realm,colliders=[]){if(Math.abs(x)>6||Math.abs(z)>6||Math.abs(x)+Math.abs(z)>8.8)return false;if(realm==='ash')return true;return !colliders.some(c=>Math.abs(x-c.x)<c.w/2+.25&&Math.abs(z-c.z)<c.d/2+.25)}
export function canTravel(x,z,gate){return Math.hypot(x-gate.x,z-gate.z)<=2}
export const RETREAT_LORE='The wizard’s retreat smells of warm cedar and rain. An old mirror holds a borrowed twilight.'
export const GATE_PROMPT='The gate answers your presence. Press E to cross.'
export const HEARTH_AMBIENT='Walk among the residents, then approach the violet gate.'
export const ASH_AMBIENT='Explore the ruins. The cyan gate leads home.'
export const RETURN_NOTE='You returned safely to the Hearth.'
export const ARRIVAL_NOTE='The gate opens onto a ruined observatory. Explore, then return through the cyan gate.'
export function explorationStatus({realm='hearth',nearRetreat=false,nearby=false,travelNote='',travelAge=Infinity,hold=2.4}={}){if(travelNote&&travelAge<hold)return travelNote;if(nearRetreat)return RETREAT_LORE;if(nearby)return GATE_PROMPT;if(travelNote)return travelNote;return realm==='hearth'?HEARTH_AMBIENT:ASH_AMBIENT}
export function frameColumn(id,row,col){if(id==='cyborg'&&row===0&&col===3)return 1;if(id==='anunnaki'){if(row===0&&col===1)return 3;if(row===2&&col===0)return 1}if(id==='pilgrim'){if(row===0)return [0,1,0,1][col];if(row===2)return [2,3,2,3][col]}return col}
