import fs from "fs";
import { File } from "nft.storage";

const howard = {
  name: "Howard",
  description:
    "young, intelligent Jewish man",
  image: new File([await fs.promises.readFile('images/Howard.png')], "Howard.png", {
    type: "image/png",
  }),
  attributes: [
    {
      name: "Howard",
      occupation: "Aerospace engineer",
      lover: "Bernadette",
      university: "MIT",
     
      attributes: [
        { trait_type: "senseOfHumour", value: 49 },
        { trait_type: "extrovert", value: 56 },
        { trait_type: "socialSkills", value: 96 },
        { trait_type: "sensitive", value: 41 },
        { trait_type: "iq", value: 124 },
      ],
    },
  ],
};

export default howard;
