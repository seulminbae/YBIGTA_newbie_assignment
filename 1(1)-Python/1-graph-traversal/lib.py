from __future__ import annotations
import copy
from collections import deque
from collections import defaultdict
from typing import DefaultDict, List


"""
TODO:
- __init__ 구현하기
- add_edge 구현하기
- dfs 구현하기 (재귀 또는 스택 방식 선택)
- bfs 구현하기
"""


class Graph:
    def __init__(self, n: int) -> None:
        """
        그래프 초기화
        n: 정점의 개수 (1번부터 n번까지)
        전체 그래프가 들어갈 list 생성해줌.
        """
        self.n: int = n
        self.graph: list[list[int]] = [[] for _ in range(n + 1)]


    
    def add_edge(self, u: int, v: int) -> None:
        """
        양방향 간선 추가
        graph[u]에 v를 추가 = u번째 노드에 v가 연결됨을 나타내줌.
        양방향이므로 쌍방 추가
        """
        self.graph[u].append(v)
        self.graph[v].append(u)
    
    def dfs(self, start: int) -> list[int]:
        """
        깊이 우선 탐색 (DFS)
        
        구현 방법 선택:
        1. 재귀 방식: 함수 내부에서 재귀 함수 정의하여 구현 < 재귀 방식 선택!
        2. 스택 방식: 명시적 스택을 사용하여 반복문으로 구현

        1. 결과를 저장할 result, 해당 노드 방문 여부를 저장할 visited 리스트 생성
        재귀 함수 부분만 따로 내부 함수 정의
         - 현재 정점을 방문으로 기록 -> 근처의 미방문 정점을 탐색하는 과정 반복
        
        
        """
        result: list[int] = []
        visited: list[bool] = [False] * (self.n + 1)

        def _dfs(node: int) -> None:
            visited[node] = True
            result.append(node)
            
            for adj in sorted(self.graph[node]):
                if not visited[adj]:
                    _dfs(adj)

        _dfs(start)
        return result
        # 구현하세요!
    
    def bfs(self, start: int) -> list[int]:
        """
        너비 우선 탐색 (BFS)
        큐를 사용하여 구현

        0. 시작점은 방문 처리.
        1. 방문 노드 기준으로 근처 노드 정렬 -> 미방문 노드 방문하고 큐에 append
        """
        result: list[int] = []
        visited: list[bool] = [False] * (self.n + 1)
        q: deque[int] = deque([start])
        
        visited[start] = True

        while q:
            node = q.popleft() 
            result.append(node)

            for adj in sorted(self.graph[node]): 
                if not visited[adj]:
                    visited[adj] = True 
                    q.append(adj) 
        
        return result
            
        # 구현하세요!
    
    def search_and_print(self, start: int) -> None:
        """
        DFS와 BFS 결과를 출력
        """
        dfs_result = self.dfs(start)
        bfs_result = self.bfs(start)
        
        print(' '.join(map(str, dfs_result)))
        print(' '.join(map(str, bfs_result)))

