# BibtexTools

用于检测BibTeX的MATLAB工具集，包含两个功能：比较BibTeX文件差异和检测未引用文献，和一个读取BibTex的函数。

## 面向人群

这个工具集适合新手学生在撰写论文时管理参考文献使用情况。

## 功能介绍

### 1. BibTeX文件比较工具(`CompareBibTex`)
比较两个不同版本的BibTeX文件，找出新增、删除和共有的参考文献条目。

**主要功能**：
- 比较新旧版本的`.bib`文件
- 识别被删除的参考文献条目
- 识别新添加的参考文献条目
- 显示统计信息和具体变化

**使用示例**：
```matlab
oldBibPath = 'old.bib';
newBibPath = 'new.bib';
[deleted, added, common] = CompareBibTexByEntry(oldBibPath, newBibPath);
```

### 2. 未引用参考文献检测工具(`FindUnreferencedCites`)
分析`.bib`文件中的参考文献条目是否被指定的LaTeX文件引用。

**主要功能**：
- 从BibTeX文件读取所有参考文献条目
- 从LaTeX文件中提取引用
- 识别未被任何LaTeX文件引用的文献条目
- 提供详细的统计信息，包括引用比例
- 批量处理多个`.tex`文件

**支持的引用格式**：
- `\cite{entry}`

**使用示例**：
```matlab
texPaths = {'paper.tex', 'appendix.tex'};
bibPath  = 'references.bib';
[unreferenced, stats] = FindUnreferencedCitations(bibPath, texPaths);

```

### 3. BibTeX 文件读取辅助函数(`ReadBibEntries`)
读取BibTeX文件并提取参考文献条目信息。

**支持的BibTeX条目格式**：
- **基本格式**：
```bibtex
@entryType{entry,
    field1 = {value1}, 
    field2 = {value2},
    ...
}
```
 
- **必备字段**：
  - `entryType`：条目类型（如`article`、`book`、`inproceedings`等）
  - `entry`：引文键（如`Hemingway1952老人与海`）
- **可选字段**：任意数量的其他字段，如`title`, `author`, `journal`, `year`等

**支持的条目示例**：
```bibtex
@book{Hemingway1952老人与海,
    title={老人与海},
    author={Hemingway, Ernest},
    year={1952},
    publisher={Charles Scribner's Sons}
}
```

**注意事项**：
- 函数只提取每个条目的`entryType`和`entry`
- 不验证其他字段的内容和完整性

## 系统要求
- MATLAB
