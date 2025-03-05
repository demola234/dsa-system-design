import random

def select_game():
    print("\nSelect a game:")
    print("1. Rock, Paper, Scissors")
    print("2. Guess the Number")
    print("3. Exit")
    choice = input("Enter your choice: ")
    return choice

def play_rock_paper_scissors():
    print("\nLet's play Rock, Paper, Scissors!")
    choices = ["rock", "paper", "scissors"]
    while True:
        user_choice = input("Enter your choice (rock, paper, scissors): ").lower()
        if user_choice not in choices:
            print("Invalid choice. Please try again.")
            continue
        computer_choice = random.choice(choices)
        print("Computer chose:", computer_choice)

        if user_choice == computer_choice:
            print("It's a tie!")
        elif (user_choice == "rock" and computer_choice == "scissors") or \
             (user_choice == "paper" and computer_choice == "rock") or \
             (user_choice == "scissors" and computer_choice == "paper"):
            print("You win!")
        else:
            print("Computer wins!")

        play_again = input("Do you want to play again? (yes/no): ").lower()
        if play_again != "yes":
            print("Thanks for playing Rock, Paper, Scissors!")
            break

def play_guess_the_number():
    print("\nLet's play Guess the Number!")
    secret_number = random.randint(1, 100)
    attempts = 0

    while True:
        try:
            guess = int(input("Enter your guess (between 1 and 100): "))
        except ValueError:
            print("Please enter a valid number.")
            continue

        attempts += 1
        if guess < secret_number:
            print("Too low!")
        elif guess > secret_number:
            print("Too high!")
        else:
            print(f"Congratulations! You guessed the number in {attempts} attempts.")
            break

    play_again = input("Do you want to play again? (yes/no): ").lower()
    if play_again == "yes":
        play_guess_the_number()
    else:
        print("Thanks for playing Guess the Number!")

def main():
    while True:
        choice = select_game()
        if choice == "1":
            play_rock_paper_scissors()
        elif choice == "2":
            play_guess_the_number()
        elif choice == "3":
            print("Thanks for playing! Goodbye!")
            break
        else:
            print("Invalid choice. Please try again.")

# Run the main function
main()
