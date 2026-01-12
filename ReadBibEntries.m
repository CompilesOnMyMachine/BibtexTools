function entries = ReadBibEntries(filename)
%READBIBENTRIES 读取.bib文件中所有条目的entryType和entry

% 读取文件
fileID = fopen(filename, 'r', 'n', 'UTF-8');
content = fscanf(fileID, '%c', inf);
fclose(fileID);

% 匹配模式: @type{entry, ... }
pattern = '@(\w+)\s*\{\s*([^,]+)\s*,';
matches = regexp(content, pattern, 'tokens');

% 先统计有效条目数量
validCount = 0;
for i = 1:length(matches)
    match = matches{i};
    if length(match) >= 2
        validCount = validCount + 1;
    end
end

% 预先分配结构体数组
entries = struct('type', cell(1, validCount), 'entry', cell(1, validCount));

% 填充数据
entryIdx = 1;
for i = 1:length(matches)
    match = matches{i};
    if length(match) >= 2
        entries(entryIdx).type = strtrim(match{1});
        entries(entryIdx).entry = strtrim(match{2});
        entryIdx = entryIdx + 1;
    end
end
end