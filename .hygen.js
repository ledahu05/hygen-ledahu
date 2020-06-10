const CHILD_SEPARATOR = "/"
const GRANDCHILDREN_SEPARATOR = "|"
const COMPONENT_SEPARATOR = ","
const PROPS_SEPARATOR = ":"
const TYPE = 3
const PROPS = 2
const WRAPPER = 1
const NAME = 0
const ELEMENT = "EL"
const FC = "FC"

const declaredELName = []
const declaredWrapperName = []
const declaredFCName = []
const initialEL = []
const getInitializeData = ({ type, name }) => {
  const init = [{ name: "", value: "" }]
  if (type === "EL") {
    init[0].name = name.toLowerCase()
    let i = 0
    while (initialEL[init[0].name]) {
      i++
      init[0].name = init[0].name + i
    }
    initialEL[init[0].name] = true
  }
  return init
}

const mapChildrenToComponent = (children, grandchildren = "") => {
  // console.log("children > mapChildrenToComponent", children)
  let defs = []
  let gChildren = grandchildren.split(GRANDCHILDREN_SEPARATOR)
  // console.log("grandchildren > mapChildrenToComponent", gChildren)

  if (children) {
    children.split(CHILD_SEPARATOR).forEach((cChild, index) => {
      // console.log("found child", cChild)
      const childTokens = cChild.split(COMPONENT_SEPARATOR)
      const childName = childTokens[NAME].split(PROPS_SEPARATOR)[0]
      const def = {
        name: childName,
        wrapperName: childName + "Wrapper",
        wrapperElement: childTokens[WRAPPER] || "div",
        props: childTokens[PROPS]
          ? "{" +
            childTokens[PROPS].replace("[", "")
              .replace("]", "")
              .split(PROPS_SEPARATOR)
              .join(COMPONENT_SEPARATOR) +
            ", ...props }"
          : "{ ...props }",
        propsList: childTokens[PROPS]
          ? childTokens[PROPS].split(PROPS_SEPARATOR)
          : [],
        children:
          gChildren[index] !== ""
            ? mapChildrenToComponent(gChildren[index], "")
            : [],
        type: childTokens[NAME].split(PROPS_SEPARATOR)[1]
          ? childTokens[NAME].split(PROPS_SEPARATOR)[1]
          : ELEMENT,
        init: [{ name: "", value: "" }],
      }

      const initializeData = getInitializeData(def)
      def.init = initializeData
      defs.push(def)
    })
    return defs
  }
  return defs
}

const getDef = (name, children) => {
  const componentName = name
    .split(COMPONENT_SEPARATOR)
    [NAME].trim()
    .split(PROPS_SEPARATOR)[0]

  const propsToken = name.split(COMPONENT_SEPARATOR)[PROPS]
  return {
    name: componentName,
    wrapperName: componentName + "Wrapper",
    wrapperElement: name.split(COMPONENT_SEPARATOR)[WRAPPER]
      ? name.split(COMPONENT_SEPARATOR)[WRAPPER].trim()
      : "div",
    props: propsToken
      ? "{" +
        propsToken
          .replace("[", "")
          .replace("]", "")
          .split(PROPS_SEPARATOR)
          .join(COMPONENT_SEPARATOR) +
        ", ...props }"
      : "{ ...props }",
    propsList: propsToken
      ? propsToken.replace("[", "").replace("]", "").split(PROPS_SEPARATOR)
      : [],
    children,
    type: name.split(COMPONENT_SEPARATOR)[NAME].split(PROPS_SEPARATOR)[1]
      ? name.split(COMPONENT_SEPARATOR)[NAME].split(PROPS_SEPARATOR)[1]
      : ELEMENT,
  }
}

module.exports = {
  helpers: {
    childSeparator: () => CHILD_SEPARATOR,
    componentSeparator: () => COMPONENT_SEPARATOR,
    propsSeparator: () => PROPS_SEPARATOR,
    debug: s => console.log(s),
    getDef,
    mapChildrenToComponent,
    getTreeDef: (name, children, grandchildren = []) => {
      let chDef = mapChildrenToComponent(children, grandchildren)
      let treeDef = getDef(name, chDef)
      // console.log(treeDef);
      return treeDef
    },
    outputComponent: (cDef, render) => {
      let treeDef = cDef
      const children = treeDef.children
      children.forEach(child => {
        render(child)
        const gChildren = child.children
        gChildren.forEach(gChild => {
          render(gChild)
        })
      })

      render(cDef)
    },
    getCurrentDir: () => {
      return process.cwd()
    },
    parse: item => {
      return getDef(item, [])
    },
    outputELDeclaration: (cDef, declareEL) => {
      const { name } = cDef
      if (!declaredELName[name]) {
        declaredELName[name] = true
        declareEL(cDef)
      }
    },
    outputWrapperDeclaration: (cDef, declareWrapper) => {
      const { wrapperName } = cDef
      if (!declaredWrapperName[wrapperName]) {
        declaredWrapperName[wrapperName] = true
        declareWrapper(cDef)
      }
    },
    outputFC: (cDef, declareFC) => {
      const { name } = cDef
      if (!declaredFCName[name]) {
        declaredFCName[name] = true
        declareFC(cDef)
      }
    },
  },
}
