syn case match

syn keyword Type    void int char float long unsigned double string
syn keyword Type    obj_t node_t edge_t graph_t cloneG

syn keyword gvprBuiltin     graph subg isSubg fstsubg nxtsubg isDirect isStrict
syn keyword gvprBuiltin     nNodes nEdges 

syn keyword gvprBuiltin     node subnode fstnode nxtnode nxtnode_sg isNode
syn keyword gvprBuiltin     isSubnode indegreeOf outdegreeOf degreeOf
syn keyword gvprBuiltin     fstin fstout nxtin nxtout hasAttr aget aset

syn keyword gvprBuiltin     print sprintf 

hi def link gvprBuiltin     Function

syn keyword Statement       break continue return
syn keyword Conditional     if else switch
syn keyword Repeat          for forr while

syn keyword gvprPattern     BEGIN BEG_G N E END_G END
syn match gvprVariable      "\$\w*"

hi def link gvprPattern     Special
hi def link gvprVariable    Special

syn region gvprBlock    start="{" end="}" transparent fold
syn region gvprParen    start="(" end=")" transparent

syn region gvprComment  start="^#" end="$"
syn region gvprComment  start="//" end="$"
syn region gvprComment  start="/\*" end="\*/"

hi def link gvprComment     Comment

syn region String      start=+"+ end=+"+
syn region String      start=+'+ end=+'+

syn match Integer   "\d\+"

hi def link Integer         Number

" Add $ to keyword characters
setl iskeyword+=36
