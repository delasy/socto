const CleanCSS = require('clean-css')
const HTMLMinifier = require('html-minifier')
const UglifyJS = require('uglify-js')
const mime = require('mime-types')

const types = {
  EXPRESSION: 'Expression',
  ELSE_STATEMENT: 'ElseStatement',
  ENDIF_STATEMENT: 'EndifStatement',
  IF_STATEMENT: 'IfStatement',
  STRING_LITERAL: 'StringLiteral'
}

const codegen = (items) => {
  let output = ''

  for (const item of items) {
    output += item.value
  }

  return output
}

const evaluate = (body, data) => {
  const varKeys = Object.keys(data).sort()
  const varValues = []

  for (const varKey of varKeys) {
    varValues.push(data[varKey])
  }

  varKeys.push('link')

  varValues.push((path) => {
    return data.PUBLIC_URL + path
  })

  while (true) {
    try {
      // eslint-disable-next-line no-new-func
      return new Function(...varKeys, body).apply(null, varValues)
    } catch (err) {
      const varName = err.message.slice(0, -15)

      if (
        err instanceof ReferenceError &&
        err.message.endsWith(' is not defined') &&
        /^[_$a-zA-Z\xA0-\uFFFF][_$a-zA-Z0-9\xA0-\uFFFF]*$/.test(varName)
      ) {
        varKeys.push(err.message.slice(0, -15))
        varValues.push(undefined)

        continue
      }

      return body
    }
  }
}

const getCacheTTL = (cacheTTL) => {
  return (cacheTTL || 0) === 0 ? 'no-cache' : `max-age=${cacheTTL}`
}

const getMimeType = (name, mimeType) => {
  return mimeType || mime.lookup(name) || undefined
}

const parseExpression = (code, i) => {
  const start = i
  let value = ''

  for (i += 3; i < code.length; i++) {
    if (code[i] === ' ' && code[i + 1] === '}' && code[i + 2] === '}') {
      break
    } else {
      value += code[i]
    }
  }

  return {
    type: types.EXPRESSION,
    start: start,
    end: i + 2,
    value: value
  }
}

const parseElseStmt = (code, i) => {
  return {
    type: types.ELSE_STATEMENT,
    start: i,
    end: i + 9
  }
}

const parseEndifStmt = (code, i) => {
  return {
    type: types.ENDIF_STATEMENT,
    start: i,
    end: i + 10
  }
}

const parseIfStmt = (code, i) => {
  const start = i
  let test = ''

  for (i += 6; i < code.length; i++) {
    if (code[i] === ' ' && code[i + 1] === '}' && code[i + 2] === '}') {
      break
    } else {
      test += code[i]
    }
  }

  const consequent = []
  let alternate = null

  for (i += 3; i < code.length; i++) {
    const stmt = parse(code.substring(i), [], true)

    stmt.start += i
    stmt.end += i

    if (stmt.type === types.ENDIF_STATEMENT) {
      i = stmt.end
      break
    } else if (stmt.type === types.ELSE_STATEMENT) {
      alternate = []
      i = stmt.end
    } else {
      if (alternate === null) {
        consequent.push(stmt)
      } else {
        alternate.push(stmt)
      }

      i = stmt.end
    }
  }

  return {
    type: types.IF_STATEMENT,
    start: start,
    end: i,
    test: test,
    consequent: consequent,
    alternate: alternate
  }
}

const parseStringLiteral = (code, i) => {
  const start = i
  let str = code[i]

  for (i += 1; i < code.length; i++) {
    if (code[i] === '{' && code[i + 1] === '{') {
      break
    } else {
      str += code[i]
    }
  }

  return {
    type: types.STRING_LITERAL,
    start: start,
    end: i - 1,
    value: str
  }
}

const parse = (code, ast, reportOnly) => {
  for (let i = 0; i < code.length; i++) {
    if (code[i] === '{' && code[i + 1] === '{') {
      if (code.substring(i, i + 6) === '{{ if ') {
        const stmt = parseIfStmt(code, i)

        if (reportOnly) {
          return stmt
        }

        ast.push(stmt)
        i = stmt.end

        continue
      } else if (code.substring(i, i + 11) === '{{ endif }}') {
        const stmt = parseEndifStmt(code, i)

        if (reportOnly) {
          return stmt
        }

        ast.push(stmt)
        i = stmt.end

        continue
      } else if (code.substring(i, i + 10) === '{{ else }}') {
        const stmt = parseElseStmt(code, i)

        if (reportOnly) {
          return stmt
        }

        ast.push(stmt)
        i = stmt.end

        continue
      }

      const stmt = parseExpression(code, i)

      if (reportOnly) {
        return stmt
      }

      ast.push(stmt)
      i = stmt.end

      continue
    }

    const stmt = parseStringLiteral(code, i)

    if (reportOnly) {
      return stmt
    }

    ast.push(stmt)
    i = stmt.end
  }
}

const walk = (items, data) => {
  for (let i = 0; i < items.length; i++) {
    const item = items[i]

    switch (item.type) {
      case types.EXPRESSION: {
        const result = String(evaluate(`return ${item.value};`, data))
        const newItems = []

        for (let j = 0; j < result.length; j++) {
          const stmt = parse(result.substring(j), [], true)

          stmt.start += j
          stmt.end += j

          newItems.push(stmt)

          j = stmt.end
        }

        walk(newItems, data)
        items.splice(i, 1, ...newItems)

        break
      }
      case types.IF_STATEMENT: {
        const result = evaluate('return !!(' + item.test + ');', data)
        let newItems = []

        if (result === true) {
          newItems = [...item.consequent]
        } else {
          if (item.alternate === null) {
            newItems = []
          } else {
            newItems = [...item.alternate]
          }
        }

        walk(newItems, data)
        items.splice(i, 1, ...newItems)

        break
      }
    }
  }
}

const render = (code, data) => {
  const ast = []

  parse(code, ast)
  walk(ast, data)

  return codegen(ast)
}

const renderCSS = (code, vars = {}) => {
  return new CleanCSS().minify(render(code, vars)).styles || ''
}

const renderFile = (name, mimeType, code, vars = {}) => {
  const renderers = {
    'application/javascript': renderJS,
    'application/json': renderJSON,
    'application/xml': renderXML,
    'text/css': renderCSS,
    'text/html': renderHTML,
    'text/plain': renderTXT
  }

  const key = getMimeType(name, mimeType) || 'text/plain'
  return renderers[key](code, vars)
}

const renderHTML = (code, vars = {}) => {
  const html = HTMLMinifier.minify(render(code, vars), {
    collapseBooleanAttributes: true,
    collapseInlineTagWhitespace: true,
    collapseWhitespace: true,
    continueOnParseError: true,
    decodeEntities: true,
    keepClosingSlash: true,
    minifyCSS: true,
    minifyJS: true,
    quoteCharacter: '"',
    removeComments: true,
    removeRedundantAttributes: true,
    removeScriptTypeAttributes: true,
    removeStyleLinkTypeAttributes: true,
    sortAttributes: true,
    sortClassName: true,
    useShortDoctype: true
  })

  const regex = new RegExp(
    '<script(.+)type="(application\\/json|application\\/ld\\+json)"(.*)>' +
    '([^]+?)<\\/script>',
    'g'
  )

  return html.replace(regex, (match, g1, type, g3, json) => {
    const newJson = renderJSON(json, vars)
    return `<script${g1}type="${type}"${g3}>${newJson}</script>`
  })
}

const renderJS = (code, vars = {}) => {
  return UglifyJS.minify(render(code, vars)).code || ''
}

const renderJSON = (code, vars = {}) => {
  return JSON.stringify(JSON.parse(render(code, vars)))
}

const renderTXT = (code, vars = {}) => {
  return render(code, vars)
}

const renderXML = (code, vars = {}) => {
  const xml = HTMLMinifier.minify(render(code, vars), {
    collapseBooleanAttributes: true,
    collapseInlineTagWhitespace: true,
    collapseWhitespace: true,
    continueOnParseError: true,
    decodeEntities: true,
    keepClosingSlash: true,
    quoteCharacter: '"',
    removeComments: true,
    removeRedundantAttributes: true,
    sortAttributes: true,
    sortClassName: true
  })

  return xml.replace(/\?> </g, '?><')
}

module.exports = {
  getCacheTTL,
  getMimeType,
  render,
  renderCSS,
  renderFile,
  renderHTML,
  renderJS,
  renderJSON,
  renderTXT,
  renderXML
}
