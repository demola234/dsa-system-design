package main

import (
	"fmt"
	"strconv"
	"strings"
)

func MinMax(arr []int) [2]int {
	min, max := arr[0], arr[0]
	for _, v := range arr[1:] {
		if v < min {
			min = v
		} else if v > max {
			max = v
		}
	}
	return [2]int{min, max}

}

func ToCamelCase(s string) string {
	result := ""
	words := strings.FieldsFunc(s, func(r rune) bool {
		return r == '-' || r == '_'
	})

	for i, word := range words {
		if i == 0 {
			result += word
		} else {
			result += strings.Title(word)
		}
	}

	return result
}

func IsValidWalk(walk []rune) bool {
	if len(walk) != 10 {
		return false
	}
	// if the path is repeated, it will return to the starting point
	// so the sum of the coordinates should be 0
	x, y := 0, 0
	for _, v := range walk {
		switch v {
		case 'n':
			y++
		case 's':
			y--
		case 'e':
			x++
		case 'w':
			x--
		}
	}

	fmt.Println(x, y)
	return x == 0 && y == 0

}

func TwoToOne(s1 string, s2 string) string {
	result := ""
	for _, v := range s1 + s2 {
		if !strings.Contains(result, string(v)) {
			result += string(v)
			// sort the string
			for i := len(result) - 1; i > 0; i-- {
				if result[i] < result[i-1] {
					result = result[:i-1] + string(result[i]) + string(result[i-1]) + result[i+1:]
				}
			}
		}

	}

	return result

}

func LongestConsec(strarr []string, k int) string {
	result := ""
	for i := 0; i < len(strarr)-k+1; i++ {
		temp := strings.Join(strarr[i:i+k], "")
		if len(temp) > len(result) {
			result = temp
		}
	}
	return result
}

func FindMissingLetter(chars []rune) rune {
	c := chars[0]
	for _, v := range chars[1:] {
		if c++; v != c {
			break
		}
	}
	return c

}

func Decode(roman string) int {

	result := 0

	for i := 0; i < len(roman); i++ {
		switch roman[i] {
		case 'M':
			result += 1000
		case 'D':
			if i+1 < len(roman) && roman[i+1] == 'M' {
				result -= 500
			} else {
				result += 500
			}
		case 'C':
			if i+1 < len(roman) && (roman[i+1] == 'D' || roman[i+1] == 'M') {
				result -= 100
			} else {
				result += 100
			}
		case 'L':
			if i+1 < len(roman) && (roman[i+1] == 'C' || roman[i+1] == 'D' || roman[i+1] == 'M') {
				result -= 50
			} else {
				result += 50
			}
		case 'X':
			if i+1 < len(roman) && (roman[i+1] == 'L' || roman[i+1] == 'C') {
				result -= 10
			} else {
				result += 10
			}
		case 'V':
			if i+1 < len(roman) && (roman[i+1] == 'X' || roman[i+1] == 'L' || roman[i+1] == 'C' || roman[i+1] == 'D' || roman[i+1] == 'M') {
				result -= 5
			} else {
				result += 5
			}
		case 'I':
			if i+1 < len(roman) && (roman[i+1] == 'V' || roman[i+1] == 'X') {
				result -= 1
			} else {
				result += 1
			}
		}
	}

	return result

}

func DigitalRoot(n int) int {
	result := 0

	if n < 10 {
		return n
	}

	digitalSum := 0

	for _, digital := range fmt.Sprint(n) {
		digitalSum, _ = strconv.Atoi(string(digital))

		if digitalSum == 0 {
			continue
		}

		// if the digital is more than 10 then we need to sum the digits else we just add the digital
		if digitalSum >= 10 {
			digitalSum = DigitalRoot(digitalSum)
		}

		result += digitalSum
	}

	return DigitalRoot(result)
}

func ValidBraces(str string) bool {
	if str != "" {
		for len(str)%2 == 0 {
			str = strings.ReplaceAll(str, "()", "")
			str = strings.ReplaceAll(str, "[]", "")
			str = strings.ReplaceAll(str, "{}", "")
			if len(str) == 0 {
				return true
			} else {
				return false
			}
		}
	}

	return false
}

func toWeirdCase(str string) string {
	words := strings.Fields(str)
	result := ""

	for _, word := range words {
		modifiedWord := ""

		for i, char := range word {
			if i%2 == 0 {
				modifiedWord += strings.ToUpper(string(char))
			} else {
				modifiedWord += strings.ToLower(string(char))
			}
		}

		result += modifiedWord + " "
	}

	return strings.TrimSpace(result)

}

func CamelCase(s string) string {
	result := ""

	for _, word := range strings.Fields(s) {
		result += strings.Title(word)
	}

	return result
}

func PartsSums(ls []uint64) []uint64 {
	result := []uint64{0}

	// [0, 1, 3, 6, 10] --> [20, 20, 19, 16, 10, 0]

	for i := len(ls) - 1; i >= 0; i-- {
		result = append(result, result[len(result)-1]+ls[i])
	}

	// reverse the result
	for i, j := 0, len(result)-1; i < j; i, j = i+1, j-1 {
		result[i], result[j] = result[j], result[i]
	}

	return result
}

func Is_valid_ip(ip string) bool {

	for _, v := range strings.Split(ip, ".") {
		if len(v) > 1 && v[0] == '0' {
			return false
		} else if len(v) > 3 {
			return false
		} else if len(v) == 0 {
			return false
		}

		digital, err := strconv.Atoi(v)
		if err != nil {
			return false
		}

		if digital < 0 || digital > 255 {
			return false
		}

	}

	return true
}

func CreatePhoneNumber(numbers [10]uint) string {
	result := ""

	for i, v := range numbers {
		if i == 0 {
			result += "("
		} else if i == 3 {
			result += ") "
		} else if i == 6 {
			result += "-"
		}

		result += strconv.Itoa(int(v))
	}

	return result

}

func main() {
	fmt.Println(CreatePhoneNumber([10]uint{1, 2, 3, 4, 5, 6, 7, 8, 9, 0}))
}
