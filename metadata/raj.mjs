import fs from "fs";
import { File } from "nft.storage";

const raj = {
  name: "Raj",
  description:
    "Sensitive, kind, and caring",
    image: new File([ await fs.promises.readFile('images/Raj.png')], 'Raj.png',
    { type: 'image/png'
  }),
  
  attributes: [
    {
      name: "Raj",
      occupation: "AstroPhysics",
      lover: "Cinnamon",
      university: "Cambridge University",
    
      attributes: [
        { trait_type: "senseOfHumour", value: 93 },
        { trait_type: "extrovert", value: 43 },
        { trait_type: "socialSkills", value: 55 },
        { trait_type: "sensitive", value: 96 },
        { trait_type: "iq", value: 198 },
      ],
    },
  ],
};

export default raj;
