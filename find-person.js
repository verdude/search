const fs = require("fs/promises");

function getDepNameFromArgs() {
  return process.argv[2];
}

async function parseJson() {
  const filename = "data.json";
  const data = await fs.readFile(filename);
  const o = JSON.parse(data.toString());
  return o;
}

async function search() {
  const data = await parseJson();
  const dependentName = getDepNameFromArgs();
  const re = new RegExp(dependentName, 'i');

  data.forEach((el) => {
    for (let i = 1; i <= 10; i++) {
      let otherFirst = `other_${i}_first_name`;
      let otherLast = `other_${i}_last_name`;
      if (!el.hasOwnProperty(otherFirst) || !el.hasOwnProperty(otherLast)) {
        console.warn("missing keys:", otherFirst, otherLast, "for object.");
        break;
      }

      const fullname = `${el[otherFirst]} ${el[otherLast]}`;
      if (re.test(fullname)) {
        console.info("Provided Name:", dependentName, "matches dependent name:", fullname);
        console.info("Account Holder Name:", el.first_name, el.last_name);
        break;
      }
    }
  });
}

search();
