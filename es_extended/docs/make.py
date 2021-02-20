# Copyright (c) Jérémie N'gadi
#
# All rights reserved.
#
# Even if 'All rights reserved' is very clear :
#
#   You shall not use any piece of this software in a commercial product / service
#   You shall not resell this software
#   You shall not provide any facility to install this particular software in a commercial product / service
#   If you redistribute this software, you must link to ORIGINAL repository at https://github.com/ESX-Org/es_extended
#   This copyright should appear in every part of the project code

import os
import glob
import markdown2

from pathlib         import Path
from luadoc.parser   import DocParser
from luadoc.printers import to_pretty_json

source_files = glob.glob('../**/*.lua', recursive=True)
source_files = ['../server/classes/player.lua']

colors = {
  'string' : '#46a0f0',
  'boolean': '#f0ac46',
  'number' : '#d300eb',
  'custom' : '#32a83e',
  'any'    : '#ccc',
  'nil'    : '#ccc',
}

def create_markdown_from_class(cls, file_name):

  md = ''

  md = md + '## class ' + cls.name + '\n'
  md = md + '*' + file_name + '*\n\n\n\n'

  methodCount = 0

  methods_sorted = sorted(cls.methods, key=lambda method: method.name)

  for method in methods_sorted:

    if methodCount > 0:
      md = md + '---\n'

    if method.returns[0].type.id != 'nil':
      md = md + '<span style="color:' + colors[method.returns[0].type.id] + '">' + method.returns[0].type.id + '</span> '

    md = md + '**' + method.name + '** **(** '

    paramCount = 0

    for param in method.params:

      if paramCount > 0:
        md = md + ', '

      md = md + '<span style="color:' + colors[param.type.id] + '">' + param.type.id + '</span> ' + param.name

      paramCount = paramCount + 1

    md = md + ' **)**\n\n'

    for param in method.params:
      md = md + '* <span style="color:' + colors[param.type.id] + '">' + param.type.id + '</span> ' + param.name + ' *<span style="color: #888">' + param.desc + '</span>*\n\n'

    md = md + '\n'

    if method.short_desc != '':
      md = md + '> \n*' + method.short_desc + '*\n'

    if method.desc != '':
      lines = method.desc.split('\n')

      for line in lines:
        md = md + '>' + line + '\n'

      paramCount = paramCount + 1

    md = md + '\n'

    methodCount = methodCount + 1

  return md


def create_html_from_class(cls, file_name):

  md   = create_markdown_from_class(cls, file_name)

  html = ''
  html = html + '<html>'
  html = html + '  <head>'
  html = html + '    <title>class ' + cls.name + '</title>'
  html = html + '    <link rel="stylesheet" type="text/css" href="app.css" />'
  html = html + '  </head>'
  html = html + '  <body>'
  html = html + markdown2.markdown(md)
  html = html + '  </body>'
  html = html + '</html>'

  return html

for raw_path in source_files:

  path       = Path(raw_path)
  lua_file   = open(raw_path, 'r')
  lua_source = lua_file.read()
  rel_path   = path.relative_to('..').as_posix()

  module = DocParser().build_module_doc_model(lua_source, rel_path)


  for cls in module.classes:

    md   = create_markdown_from_class(cls, rel_path)
    html = create_html_from_class(cls, rel_path)

    md_file = open('./generated/markdown/' + cls.name + '.md', 'w')
    md_file.write(md)
    md_file.close()

    html_file = open('./generated/html/' + cls.name + '.html', 'w')
    html_file.write(html)
    html_file.close()

  lua_file.close()

