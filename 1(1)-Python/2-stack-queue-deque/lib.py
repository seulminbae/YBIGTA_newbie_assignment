from __future__ import annotations
from collections import deque


"""
TODO:
- rotate_and_remove 구현하기 
"""


def create_circular_queue(n: int) -> deque[int]:
    """1부터 n까지의 숫자로 deque를 생성합니다."""
    return deque(range(1, n + 1))

def rotate_and_remove(queue: deque[int], k: int) -> int:
    """
    큐에서 k번째 원소를 제거하고 반환합니다.
    """
    save_queue: deque[int] = deque()
    real_k = (k-1) % len(queue)

    for _ in range(real_k):
        a=queue.popleft()
        save_queue.append(a)
    result=queue.popleft()
    while len(save_queue)>0:
        a=save_queue.popleft()
        queue.append(a)
    
    return result
    # 구현하세요!