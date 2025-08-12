local modern = 'true'

function search()
  local query = get('query').get_contents()
  local str = string.gsub(query, "%+", "%%2B")
  local res = fetch({
    url = "https://api.fsh.plus/buss?new=" .. modern .. "&q=" .. str
  })
  local html = ''
  if res.extra.type=='none' then
    html = ''
  elseif res.extra.type=='math' then
    html = '<div class="extra-math">' .. query .. ' = ' .. res.extra.value .. '</div>'
  else
    html = '<div class="extra-' .. res.extra.type .. '">' .. res.extra.value .. '</div>'
  end
  if window ~= nil then
    for i, s in ipairs(res.results) do
      html = html .. '<div style="--color:' .. s.color .. '">' .. (#s.favicon>0 and ('<img src="' .. s.favicon .. '" onerror="this.remove()">') or "") ..
        '<div><a href="buss://' .. s.url .. '" ip="' .. (s.ip or '') .. '">' .. (s.quality==2 and '⭐' or (s.quality==1 and '✔️' or '')) .. (#s.title>0 and s.title or s.url) .. '</a><p>' .. s.desc .. '</p></div></div>'
    end
    if modern=='false' then
      get('run').set_contents('<img src="x" onerror="document.querySelectorAll(`a`).forEach(a=>a.onclick=(evt)=>{evt.stopPropagation();evt.preventDefault();let cat=window.top.document.querySelector(`#url,#toolbar_searchbar`);cat.value=cat.getAttribute(`ip`);const enterEvent = new KeyboardEvent(`keydown`,{bubbles:true,cancelable:true,key:`Enter`,code:`Enter`,keyCode:13,which:13});cat.dispatchEvent(enterEvent);})" style="display:none">')
    end
  else
    for i, s in ipairs(res.results) do
      html = html .. (s.quality==2 and '⭐' or (s.quality==1 and '✔️' or '➖')) .. (#s.title>0 and (s.title .. ' (' .. s.url .. ')') or s.url) .. (#s.desc>0 and ('\n' .. s.desc) or '') .. '\n'
    end
  end
  get('results').set_contents(html)
end

get('search').on_click(function()
  search()
end)
get('query').on_submit(function()
  search()
end)

if window ~= nil then
  if window.query.q ~= nil then
    get('query').set_contents(window.query.q)
  end
  if string.find(window.location, 'timemachine') then
    modern = 'false'
  end
end

search()






