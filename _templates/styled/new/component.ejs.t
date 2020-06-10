---
to: <% if (path) { %><%= path %>/<%= name.split(',')[0].trim().split(':')[0].trim() %>.jsx<% } else { %><%= name.split(',')[0].trim().split(':')[0].trim() %>.jsx<% } %>
---
import React from 'react'
import styled from 'styled-components'

<%= h.outputComponent(h.getTreeDef(name, children, locals.grandchildren ? grandchildren : ''), declareComponent) %>


<%
function declareComponent(cDef, children = cDef.children) {
  if(cDef.type === 'EL' || cDef.type === 'ELI') { %>
<%= h.outputELDeclaration(cDef,declareEL) %>

<% } else { %>
<%= h.outputWrapperDeclaration(cDef,declareWrapper) %>
<%= h.outputFC(cDef,declareFC) %>

<% } %>
<% } %>

<% function declareEL({name, wrapperElement}) { %>
const <%= name %> = styled.<%= wrapperElement  %>``
<% } %>

<% function declareWrapper({wrapperName, wrapperElement}) { %>
const <%= wrapperName %> = styled.<%= wrapperElement  %>``
<% } %>

<% function declareFC({name, wrapperName, props, propsList, children}) { %>
  export const <%= name %> = (<%= props %>) => {
    <%= initializeChildrenProps(children, propsList) %>
    return (
  <<%= wrapperName %>><%=renderChildren(children, propsList) %></<%= wrapperName %>> 
  )}
<% } %>


<% function initializeChildrenProps(children, parentPropsList) {
  children.forEach(child => { 
    initializeChildProps(child, parentPropsList)
    })
} %>

<% function initializeChildProps(child, parentPropsList) { %>
    <% if(child.type === 'EL') { console.log('child', child) %>
const <%=child.init[0].name%> = ""
    <% } else if (child.type === 'ELI' && !parentPropsList.includes(child.name.toLowerCase()+'s')) {%>
const <%=h.changeCase.lower(child.name)%>s = []
    <% } else if (child.type === 'FC') {
      const newProps =  child.propsList.filter(childProp => !parentPropsList.includes(childProp)); 
      newProps.forEach(newProp => { %>
const <%=h.changeCase.lower(newProp)%> = <%= newProp.endsWith('s') ? '[]' : '""' %>
      <%})%>
<%    } %>
<% } %>

<% function renderChildren(children, parentPropsList) {
  children.forEach(child => {
    renderChild(child, parentPropsList)
  })
} %>

<% function renderChild(child, parentPropsList) {
  if(child.type === 'EL') { %>
  <<%= child.name %>>{<%=child.init[0].name%>}</<%= child.name %>>

<% } else if(child.type === 'ELI') { %>

{<%=h.changeCase.lower(child.name)%>s.map((<%=h.changeCase.lower(child.name)%>,i) => (
  <<%= child.name %> key={i}>{<%=h.changeCase.lower(child.name)%>}</<%= child.name %>>
))}
  

<% } else if(child.type === 'FCI') { %>

{items.map((item,i) => (
  <<%= child.name %> key={i} item={item} <%=renderProps(child) %>/>
))}
  

<% } else { %>
  <<%= child.name %> <%=renderProps(child, parentPropsList) %>/>
<% } %>
<% } %>


<% function renderProps({propsList}, parentPropsList) {
  let propsStr = '';
  propsList.forEach(prop => { %> <%=prop%>={<%=prop%>} <% }) %> {...props}
<% } %>
