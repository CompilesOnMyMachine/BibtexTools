clear; clc

texPaths = {'paper.tex', 'appendix.tex'};
bibPath  = 'references.bib';

[unreferenced, stats] = FindUnreferencedCitations(bibPath, texPaths);

%% 函数
function [unreferencedEntries, stats] = FindUnreferencedCitations(bibPath, texPaths)
% 查找.bib文件中未被任何.tex文件引用的参考文献
% 输入:
%   bibPath - .bib文件名
%   texPaths - .tex文件名的cell数组
% 输出:
%   unreferencedEntries - 未被引用的entry列表
%   stats - 统计信息结构体

% 读取.bib文件的所有entry
bibEntries = ReadBibEntries(bibPath);
allEntries = {bibEntries.entry};
fprintf('从.bib文件中读取到 %d 个参考文献entry\n', length(allEntries));

% 从所有.tex文件中提取引用
allCitations = {};
for i = 1:length(texPaths)
    if exist(texPaths{i}, 'file')
        citations = ExtractCitationsFromTex(texPaths{i});
        allCitations = [allCitations, citations];
        fprintf('从 %s 中提取到 %d 个引用\n', texPaths{i}, length(citations));
    else
        warning('文件不存在: %s', texPaths{i});
    end
end

% 获取唯一的引用entry
uniqueCitations = unique(allCitations);
fprintf('总共找到 %d 个唯一引用\n', length(uniqueCitations));

% 找出未被引用的entry
unreferencedEntries = setdiff(allEntries, uniqueCitations);

% 创建统计信息
stats = struct();
stats.total_bib_entries = length(allEntries);
stats.total_citations = length(allCitations);
stats.unique_citations = length(uniqueCitations);
stats.unreferenced_count = length(unreferencedEntries);
stats.referenced_count = stats.total_bib_entries - stats.unreferenced_count;
stats.reference_ratio = stats.referenced_count / stats.total_bib_entries;

% 显示结果
DisplayUnreferencedResults(unreferencedEntries, stats, bibPath, texPaths);
end

function citations = ExtractCitationsFromTex(texFilename)
% 从.tex文件中提取所有\cite{}引用
fileID = fopen(texFilename, 'r', 'n', 'UTF-8');
content = fscanf(fileID, '%c', inf);
fclose(fileID);

% 支持多种引用格式
citePatterns = {
    '\\cite\{([^}]+)\}',...           % \cite{entry}
    '\\cite\[[^\]]*\]\{([^}]+)\}',... % \cite[prefix]{entry}
    '\\citep\{([^}]+)\}',...          % \citep{entry}
    '\\citet\{([^}]+)\}',...          % \citet{entry}
    '\\citeauthor\{([^}]+)\}',...     % \citeauthor{entry}
    '\\citeyear\{([^}]+)\}'           % \citeyear{entry}
    };

citations = {};
for i = 1:length(citePatterns)
    matches = regexp(content, citePatterns{i}, 'tokens');
    for j = 1:length(matches)
        if ~isempty(matches{j})
            entries = strsplit(matches{j}{1}, ',');
            for k = 1:length(entries)
                entry = strtrim(entries{k});
                if ~isempty(entry)
                    citations{end+1} = entry;
                end
            end
        end
    end
end
end

function DisplayUnreferencedResults(unreferencedEntries, stats, bibPath, texPaths)
% 显示未引用参考文献的结果
fprintf('\n=== 未引用参考文献分析结果 ===\n');
fprintf('Bib文件: %s\n', bibPath);
fprintf('Tex文件: %s\n', strjoin(texPaths, ', '));
fprintf('\n');

fprintf('统计信息:\n');
fprintf('  Bib文件中总entry数: %d\n', stats.total_bib_entries);
% fprintf('  所有Tex文件中总引用次数: %d\n', stats.total_citations);
% fprintf('  唯一引用entry数: %d\n', stats.unique_citations);
fprintf('  被引用的entry数: %d\n', stats.referenced_count);
fprintf('  未被引用的entry数: %d\n', stats.unreferenced_count);
fprintf('  引用比例: %.1f%%\n', stats.reference_ratio * 100);

fprintf('\n未被引用的参考文献entry:\n');
if isempty(unreferencedEntries)
    fprintf('  所有参考文献都被引用。\n');
else
    for i = 1 : min(20, length(unreferencedEntries))
        fprintf('  %d. %s\n', i, unreferencedEntries{i});
    end
    if length(unreferencedEntries) > 20
        fprintf('  ... 还有 %d 个未显示\n', length(unreferencedEntries) - 20);
    end
end
end
