import dotenv from 'dotenv';
import { NFTStorage } from 'nft.storage';
import raj from  '../metadata/raj.mjs'
import howard from  '../metadata/howard.mjs'
import leanord from  '../metadata/leanord.mjs'
import sheldon from  '../metadata/sheldon.mjs'


dotenv.config();
const apiKey = process.env.NFTSTORAGE_API_KEY;

async function main() {

const client = new NFTStorage({ token: apiKey })

const metadata = await client.store(raj);
const metadata2 = await client.store(howard);
const metadata3 = await client.store(leanord);
const metadata4 = await client.store(sheldon);

console.log(metadata.url);
console.log(metadata2.url);
console.log(metadata3.url);
console.log(metadata4.url);
}

main();