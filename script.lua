function search()
    local res = fetch({
        url = "https://api.fsh.plus/buss?new=true&q=" .. get('query').get_contents(),
        method = "GET",
        headers = { ["Content-Type"] = "application/json" },
        body = ''
    })
    local html = ''
    for i, s in ipairs(res) do
        html = html .. '<div style="--color:' .. s.color .. '">' .. (#s.favicon>0 and ('<img src="' .. s.favicon .. '" onerror="this.remove()">') or "") ..
            '<div><a href="buss://' .. s.url .. '">' .. (s.quality and "⭐" or "") .. s.title .. '</a><p>' .. s.desc .. '</p></div></div>'
    end
    get('results').set_contents(html)
end

get('search').on_click(function()
    search()
end)
get('query').on_submit(function()
    search()
end)
