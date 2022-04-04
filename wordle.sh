#!/bin/bash
dict=dicts.txt

function win {
 clear
 echo -e "${stack}\n"
 echo "You won! Congraturations!"
 exit 0
}

word=$(sed -n $(shuf -i 1-$(cat ${dict} | wc -l) -n 1)p ${dict})
[[ "${#word}" != 5 ]] && echo "Unexpected error!"

correct[0]="null"
for i in `seq 5`
do
 correct+=($(echo -n "${word}" | cut -c ${i}))
done

for tries in `seq 6`
do
 while true
 do
  clear
  [[ -n ${stack} ]] && echo -e "${stack}\n"
  [[ -n ${err} ]] && echo "${err}"
  echo -n "${tries}/6 >"; read answer
  answer=${answer,,}
  err=""
  [[ "${#answer}" != 5 ]] && { err="String length must be 5!"; continue; }
  cat ${dict} | grep "^${answer}$" || { err="Not in word list!"; continue; }
  break
 done

 stack=$({ echo "${stack}"
 for i in `seq 5`
 do
  search=$(echo -n "${answer}" | cut -c ${i})
  { echo -n "${word}" | grep "${search}" >/dev/null; } && {
   [[ "${search}" = "${correct[$i]}" ]] && echo -n "\e[30;42m${search^^}\e[m" || echo -n "\e[30;43m${search^^}\e[m"
  } || {
   echo -n "\e[30;47m${search^^}\e[m"
  }
 done; })
 clear
 [[ "${answer}" = "${word}" ]] && win
done

echo -e "${stack}\n"
echo "You losed! Correct answer is \"${word}\""
