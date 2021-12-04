import fs from "fs";
import { File } from "nft.storage";

const sheldon = {
  name: "Sheldon",
  description:"highly intelligent,stubborn,meanness",
  image: new File(
    [
      await fs.promises.readFile(
        "images/Sheldon.png"
      ),
    ],
    "Sheldon.png",
    { type: "image/png" }
  ),
  attributes: [
    {
      name: "Sheldon",
      occupation: "Theoritical Physicist",
      lover: "Amy",
      university: "Caltech",
    
      attributes: [
        { trait_type: "senseOfHumour", value: 24 },
        { trait_type: "extrovert", value: 99 },
        { trait_type: "socialSkills", value: 78 },
        { trait_type: "sensitive", value: 96 },
        { trait_type: "iq", value: 117 },
      ],
    },
  ],
};

export default sheldon;
