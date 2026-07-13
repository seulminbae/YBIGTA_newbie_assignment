from lib import create_circular_queue


"""
TODO:
- simulate_card_game 구현하기
    # 카드 게임 시뮬레이션 구현
        # 1. 큐 생성
        # 2. 카드가 1장 남을 때까지 반복
        # 3. 마지막 남은 카드 반환
"""


def simulate_card_game(n: int) -> int:
    """
    카드2 문제의 시뮬레이션
    맨 위 카드를 버리고, 그 다음 카드를 맨 아래로 이동
    q의 길이가 1이 될 때까지 popleft와 그 다음 카드를 가장 right로 보내는 과정 반복
    """
    q=create_circular_queue(n)
    while len(q)!=1:
        q.popleft()
        add=q.popleft()
        q.append(add)
    
    result=q.popleft()
    return result
    # 구현하세요!

def solve_card2() -> None:
    """입, 출력 format"""
    n: int = int(input())
    result: int = simulate_card_game(n)
    print(result)

if __name__ == "__main__":
    solve_card2()