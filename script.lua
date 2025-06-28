function search()
    local query = get('query').get_contents()
    local str = string.gsub(query, "%+", "%%2B")
    local res = fetch({
        url = "https://api.fsh.plus/buss?new=true&q=" .. str,
        method = "GET",
        headers = { ["Content-Type"] = "application/json" },
        body = ''
    })
    local html = ''
    if res.extra.type=='math' then
        html = '<div class="extra-math">' .. query .. ' = ' .. res.extra.value .. '</div>'
    end
    if res.extra.type=='wiki' then
        html = '<div class="extra-wiki">' .. res.extra.value .. '</div>'
    end
    if window ~= nil then
        for i, s in ipairs(res.results) do
            html = html .. '<div style="--color:' .. s.color .. '">' .. (#s.favicon>0 and ('<img src="' .. s.favicon .. '" onerror="this.remove()">') or "") ..
                '<div><a href="buss://' .. s.url .. '">' .. (s.quality==2 and '⭐' or (s.quality==1 and '✔️' or '')) .. (#s.title>0 and s.title or s.url) .. '</a><p>' .. s.desc .. '</p></div></div>'
        end
    else
        for i, s in ipairs(res.results) do
            html = html .. (s.quality==2 and '⭐' or (s.quality==1 and '✔️' or '')) .. (#s.title>0 and (s.title .. ' (' .. s.url .. ')') or s.url) .. (#s.desc>0 and ('\n' .. s.desc) or '') .. '\n'
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

search()