import { forEach } from 'lodash';

const enums = {{enums}};
const enumsMap = {};

enums.keys().forEach(e => {
  forEach(enums(e), (v, k) => {
    if (enumsMap[k]) throw new Error(`${k}的enum名称重复`);
    const enumObj = { list: [], map: new Map() };
    forEach(v, (v1, k1) => {
      enumObj.list.push({
        value: v1[0],
        name: v1[1],
      });
      enumObj.map.set(v1[0], v1[1]);
      enumObj[k1] = v1[0];
    });
    enumsMap[k] = enumObj;
  });
});

export default enumsMap;
