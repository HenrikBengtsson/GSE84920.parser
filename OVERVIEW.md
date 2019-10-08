<%
## Reuse the package vignette
md <- R.rsp::rstring(file="vignettes/ramani-intro.md", postprocess=FALSE)

md <- unlist(strsplit(md, split="\n", fixed=TRUE))

## Drop vignette markup
md <- grep("%\\Vignette", md, fixed=TRUE, value=TRUE, invert=TRUE)

## Drop everything before the first subheader ("H2")
#md <- md[-seq_len(grep("^## ", md)[1]-1)]

## Output
cat(md, sep="\n")
%>
