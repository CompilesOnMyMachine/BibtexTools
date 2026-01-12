clear; clc

oldBibPath = 'old.bib';
newBibPath = 'new.bib';

[deleted, added, common] = CompareBibTexByEntry(oldBibPath, newBibPath);

%% 函数
function [deletedEntries, addedEntries, commonEntries] = CompareBibTexByEntry(oldBibPath, newBibPath)
% 读取和比较参考文献条目的entry，比较两个版本的BibTeX的差异
% 输入:
%   oldBibPath - 旧版本.bib文件
%   newBibPath - 新版本.bib文件
% 输出:
%   deletedEntries - 被删除的entry列表（在old中存在，在new中不存在）
%   addedEntries - 新添加的entry列表（在new中存在，在old中不存在）
%   commonEntries - 两个版本共有的entry列表

% 读取两个版本的所有entry
oldEntries = ReadBibEntries(oldBibPath);
newEntries = ReadBibEntries(newBibPath);

oldEntryNames = {oldEntries.entry};
newEntryNames = {newEntries.entry};

fprintf('旧版本: %s (%d 个entry)\n', oldBibPath, length(oldEntryNames));
fprintf('新版本: %s (%d 个entry)\n', newBibPath, length(newEntryNames));

% 找出被删除的entry
deletedEntries = setdiff(oldEntryNames, newEntryNames);

% 找出新添加的entry
addedEntries = setdiff(newEntryNames, oldEntryNames);

% 找出共有的entry
commonEntries = intersect(oldEntryNames, newEntryNames);

% 显示比较结果
DisplayComparisonResults(deletedEntries, addedEntries, commonEntries, oldBibPath, newBibPath);
end

function DisplayComparisonResults(deletedEntries, addedEntries, commonEntries, oldFile, newFile)
% 显示比较结果
fprintf('\n=== BibTeX文件比较结果 ===\n');
fprintf('比较文件: %s -> %s\n', oldFile, newFile);
fprintf('\n');

fprintf('统计信息:\n');
fprintf('  被删除的entry: %d\n', length(deletedEntries));
fprintf('  新添加的entry: %d\n', length(addedEntries));
fprintf('  共同有的entry: %d\n', length(commonEntries));

% 显示被删除的entry
fprintf('\n被删除的参考文献entry:\n');
if isempty(deletedEntries)
    fprintf('  无\n');
else
    for i = 1:min(10, length(deletedEntries))
        fprintf('  %d. %s\n', i, deletedEntries{i});
    end
    if length(deletedEntries) > 10
        fprintf('  ... 还有 %d 个未显示\n', length(deletedEntries) - 10);
    end
end

% 显示新添加的entry
fprintf('\n新添加的参考文献entry:\n');
if isempty(addedEntries)
    fprintf('  无\n');
else
    for i = 1:min(10, length(addedEntries))
        fprintf('  %d. %s\n', i, addedEntries{i});
    end
    if length(addedEntries) > 10
        fprintf('  ... 还有 %d 个未显示\n', length(addedEntries) - 10);
    end
end
end
