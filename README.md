# hygen-ledahu
Contains generators for styled-components and formik

# generator pour styled-component 
## Définir un élément:
Nom du composant:Type du composant, type html de l'élément, liste de props séparée par des espaces
Par défaut le type de composant est EL
Par défaut le type html de l'élément est div
Par défaut le composant n'a pas de props spécifique


## Les différents types de composant:
EL par défaut, correspond à un styled components directement mappé sur un élément html5
```
--name="P,p" -> const P = styled.p``
```
ELI, correspond à un EL Itérable. Pour fonctionner l'ELI est en children ou en grandchildren
```
--name="List,ul" --children="Item:ELI,li" -> va générer les styled.ul et styled.li + le map qui itère sur les li
```
FC: correpond à un styled component de functionnal component + wrapper dans le return


## Les 3 niveaux de hiérarchies
- composant root ou niveau 0
définit par le paramètre --name
- les enfants ou niveau 1
définit par le paramètre --children
Pour définir plusieurs enfants du composant root on les sépare par /
- les petits enfants ou niveau 2
définit par le paramètre --grandchildren
Pour définir plusieurs petit enfants du composant root on les sépare par |
Il doit y avoir autant de groupe de niveaux 2 (même vide) que d'élément de niveau 1.
Chaque groupe de niveau 2 est un descendant d'un élément de niveau 1.
Chaque groupe de niveau peut être constituté de plusieurs éléments séparé par des /


## Les props
ex: 
```
--name="Container:FC,,content"
```
va créer un composant fonctionnel appelé Container qui acceptera une props content et dont le wrapper sera un div

## Les initialisations des props
### Cas du composant de type EL
Ex: const P= styled.p``
Quand le parent de P va être généré, on aura :
```
const p=""
<P>{p}</P>
```
-> Le nome de la variable correspond au nom du composant en minuscule.

### Cas du composant de type ELI
Ex: ```- ex: hygen styled new --path='Description' --name="Recommandation:FC,div" --children="Intro,p/Images:FC,div,images" --grandchildren="|Image:ELI,img"```
Le composant de niveau 0 n'a pas de props définies
Le composant de niveau 1, Images déclare une props images
Le composant de niveau 2 associé à Images est Image, il est de type ELI et ne déclare pas de props


### Cas du composant de type FC
Si le composant parent ne déclare pas une props du même nom qu'une props déclarée par un composant enfant,
alors le composant parent initialise la props du composant enfant avec une variable qui est initialisée à vide
Un tableau vide si le nom de la props est au pluriel, une chaine de caractère vide sinon.

Ex0: Le composant fils déclare une props qui est déclarée dans le composant père
```hygen styled new --path='' --name="Container:FC,,items" --children="Items:FC,,items"```
```
const ItemsWrapper = styled.div``

export const Items = ({ items, ...props }) => {
  return <ItemsWrapper></ItemsWrapper>
}

const ContainerWrapper = styled.div``

export const Container = ({ items, ...props }) => {
  return (
    <ContainerWrapper>
      <Items items={items} {...props} />
    </ContainerWrapper>
  )
}
```
Ex1: Le composant fils déclare une props qui n'est pas déclarée dans le composant père
```hygen styled new --path='' --name="Container:FC" --children="Items:FC,,items"```
```
const ItemsWrapper = styled.div``

export const Items = ({ items, ...props }) => {
  return <ItemsWrapper></ItemsWrapper>
}

const ContainerWrapper = styled.div``

export const Container = ({ ...props }) => {
  const items = []

  return (
    <ContainerWrapper>
      <Items items={items} {...props} />
    </ContainerWrapper>
  )
}
```
Ex2: Même commande mais avec item au lieu de items 
```hygen styled new --path='' --name="Container:FC" --children="Items:FC,,item"```
```
const ItemsWrapper = styled.div``

export const Items = ({ item, ...props }) => {
  return <ItemsWrapper></ItemsWrapper>
}

const ContainerWrapper = styled.div``

export const Container = ({ ...props }) => {
  const item = ""

  return (
    <ContainerWrapper>
      <Items item={item} {...props} />
    </ContainerWrapper>
  )
}
```

