import { mkdir, readdir, copyFile } from 'node:fs/promises'
import { fileURLToPath } from 'node:url'
const source = new URL('../assets/characters/walk/', import.meta.url)
const target = new URL('./public/sprites/', import.meta.url)
await mkdir(target, {recursive:true})
for(const name of await readdir(source)) if(name.endsWith('.png')) await copyFile(new URL(name,source),new URL(name,target))
console.log('Copied original directional sprites into browser assets.')
