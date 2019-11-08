def clip_start(snip, length):
    # Trim first and last line (the fold markers) to length.
    snip.buffer[snip.snippet_start[0]] = snip.buffer[snip.snippet_start[0]][0:length]
    snip.buffer[snip.snippet_end[0]] = snip.buffer[snip.snippet_end[0]][0:length]
