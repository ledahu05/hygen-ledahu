---
message: |
  - hygen {bold styled} new --path=[PATH] --name [Component_Def1] --children=[Component_Def2/Component_Def3/Component_Def4] --grandchildren=[/Component_Def5|Component_Def6/] 
  - hygen {bold styled} add --name [name of the target file without extansion] --item [Component_Def1] --children=[Component_Def2/Component_Def3/Component_Def4] --grandchildren=[/Component_Def5|Component_Def6/] 
  - ex: hygen styled new --path='Description' --name="Recommandation:FC,div" --children="Intro,p/Images:FC,div,images" --grandchildren="|Image:ELI,img"
  - ex: hygen styled new --path='' --name="Description:FC,div,name title" --children="P,p/P,p/Items:FC,ul/Recommand:FC,div" --grandchildren="||Item,li|Count,p/Images,div"
---