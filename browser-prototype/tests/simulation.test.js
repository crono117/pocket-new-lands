import test from 'node:test'
import assert from 'node:assert/strict'
import {screenMotion,directionRow,allowedPosition,canTravel,frameColumn} from '../src/simulation.js'
test('screen arrows select north/east/south/west rows',()=>{for(const [x,y,row] of [[0,-1,0],[1,0,1],[0,1,2],[-1,0,3]]){const m=screenMotion(x,y);assert.equal(directionRow(m.x,m.z),row);assert.ok(Math.abs(Math.hypot(m.x,m.z)-1)<1e-10)}})
test('diagonal input retains normalized direction after movement normalization',()=>{const m=screenMotion(1,-1);assert.ok(Math.abs(m.x)<1e-10);assert.ok(m.z<0)})
test('island bounds and sanctuary obstacles reject traversal',()=>{assert.equal(allowedPosition(7,0,'hearth'),false);assert.equal(allowedPosition(5,5,'hearth'),false);assert.equal(allowedPosition(0,0,'hearth',[{x:0,z:0,w:1,d:1}]),false);assert.equal(allowedPosition(0,0,'ash',[{x:0,z:0,w:1,d:1}]),true)})
test('portal proximity is bounded and includes exact distance boundary',()=>{const gate={x:4,z:-2};assert.equal(canTravel(0,2,gate),false);assert.equal(canTravel(2,-2,gate),true);assert.equal(canTravel(4,-2,gate),true)})
test('documented sprite corrections preserve equipment frames',()=>{assert.equal(frameColumn('cyborg',0,3),1);assert.equal(frameColumn('anunnaki',0,1),3);assert.equal(frameColumn('pilgrim',2,0),2);for(const id of ['robot','cyborg','ethereal','plasma','reptilian','archangel','anunnaki','pilgrim'])for(let r=0;r<4;r++)for(let c=0;c<4;c++)assert.ok(frameColumn(id,r,c)>=0&&frameColumn(id,r,c)<4)})
