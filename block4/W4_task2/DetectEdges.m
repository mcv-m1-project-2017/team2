function [mask_only_edges] = DetectEdges(mask, algorithm, threshold)

mask_only_edges = edge(mask, algorithm, threshold);

end