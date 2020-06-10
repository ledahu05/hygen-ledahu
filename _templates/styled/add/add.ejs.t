---
inject: true
to: <%= name %>.jsx
append: true
---
<%= h.outputComponent(h.getTreeDef(item, children, locals.grandchildren ? grandchildren : ''), declareComponent) %>


<%
function declareComponent(cDef, children = cDef.children) {
  if(cDef.type === 'ELEMENT') { %>
const <%= cDef.name %> = styled.<%= cDef.wrapperElement  %>``
<% } else { %>
  const <%= cDef.wrapperName %> = styled.<%= cDef.wrapperElement  %>``
  export const <%= cDef.name %> = (<%= cDef.props %>) => {
    return (
  <<%= cDef.wrapperName %>><%=renderChildren(children) %></<%= cDef.wrapperName %>> 
  
)}
<% } %>
<% } %>

<% function renderChildren(children) {
  children.forEach(child => {
    renderChild(child)
  })
} %>

<% function renderChild(child) {
  if(child.type === 'ELEMENT') { %>
  <<%= child.name %>></<%= child.name %>>
  
<% } else { %>
  <<%= child.name %> <%=renderProps(child) %>/>
<% } %>
<% } %>

<% function renderProps({propsList}) {
  let propsStr = '';
  propsList.forEach(prop => { %> <%=prop%>="" <% }) %> {...props}
<% } %>
