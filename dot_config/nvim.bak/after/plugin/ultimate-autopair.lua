local ua=require'ultimate-autopair'

local cond = function (fn)
    return not fn.in_string() or fn.in_node("comment")
end

local configs={ua.extend_default({
    extensions={-- *ultimate-autopair-extensions-default-config*
        -- cmdtype={skip={'/','?','@','-'},p=100},
        -- filetype={p=90,nft={'TelescopePrompt'},tree=true},
        -- escape={filter=true,p=80},
        -- utf8={p=70},
        -- tsnode={p=60,separate={'comment','string','char','character',
        --     'raw_string', --fish/bash/sh
        --     'char_literal','string_literal', --c/cpp
        --     'string_value', --css
        --     'str_lit','char_lit', --clojure/commonlisp
        --     'interpreted_string_literal','raw_string_literal','rune_literal', --go
        --     'quoted_attribute_value', --html
        --     'template_string', --javascript
        --     'LINESTRING','STRINGLITERALSINGLE','CHAR_LITERAL', --zig
        --     'string_literals','character_literal','line_comment','block_comment','nesting_block_comment' --d #62
        -- }},
        -- cond={p=40,filter=true},
        -- alpha={p=30,filter=false,all=false},
        suround=false,
        -- fly={other_char={' '},nofilter=false,p=10,undomapconf={},undomap=nil,undocmap=nil,only_jump_end_pair=false},
    },
    internal_pairs={-- *ultimate-autopair-pairs-default-pairs*
        {'[',']',fly=true,dosuround=true,newline=true,space=true,cond=cond},
        {'(',')',fly=true,dosuround=true,newline=true,space=true,cond=cond},
        {'{','}',fly=true,dosuround=true,newline=true,space=true,cond=cond},
        {'"','"',suround=true,multiline=false},
        {"'","'",suround=true,cond=function(fn) return ( not fn.in_lisp() or fn.in_string() ) and cond(fn) end,alpha=true,nft={'tex'},multiline=false},
        -- {'`','`',cond=function(fn) return not fn.in_lisp() or fn.in_string() end,nft={'tex'},multiline=false},
        -- {'``',"''",ft={'tex'}},
        {'```','```',newline=true,ft={'markdown'}},
        {'<!--','-->',ft={'markdown','html'},space=true},
        {'"""','"""',newline=true,ft={'python'}},
        {"'''","'''",newline=true,ft={'python'}},
    },
})}
ua.init(configs)
