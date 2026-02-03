def swap_numbers(a: float, b: float) -> tuple[float, float]:
    """Return the pair (b, a), effectively swapping the inputs."""
    return b, a


def main() -> None:
    first = float(input("Enter the first number: "))
    second = float(input("Enter the second number: "))

    first, second = swap_numbers(first, second)

    print(f"After swapping:\nFirst number: {first}\nSecond number: {second}")


if __name__ == "__main__":
    main()
