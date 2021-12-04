import fs from "fs";
import { File } from "nft.storage";

const leanord = {
  name: " Leanord",
  description:"extremely nerdy,insecure,outgoing",
  image: new File(
    [
      await fs.promises.readFile(
        "images/Leanord.png"
      ),
    ],
    "Leanord.png",
    { type: "image/png" }
  ),
  attributes: [
    {
      name: "Leanord",
      occupation: "Experimental Physicist",
      lover: "Penny",
      university: "Princeton University",
   
      attributes: [
        { trait_type: "senseOfHumour", value: 22 },
        { trait_type: "extrovert", value: 13 },
        { trait_type: "socialSkills", value: 6 },
        { trait_type: "sensitive", value: 55 },
        { trait_type: "iq", value: 140 },
      ],
    },
  ],
};

export default leanord;
