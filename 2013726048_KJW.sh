#!/bin/bash

tput civis
declare -i cursor=2
declare -a filelist
declare -i total_num
declare -i dir_num
declare -i nor_num
declare -i spe_num
declare loadfile
declare -i mode=0
declare -i treecursor=2
declare -i hasTrashBin
declare -i treemax=2
declare treetarget
declare -a treelist
declare depth
declare -a bin
bin[0]=".."
declare -a opened

makelist()
{
	unset filelist
	total_num=0
	dir_num=-1
	nor_num=0
	spe_num=0
	filelist[0]=".."

	ls_result=`ls -X1`

	for s in $ls_result
	do
	if [ ${s:0:1} != "." ]; then
		filelist=(${filelist[@]} $s)
		total_num=$total_num+1
	fi
	done
	unset ls_result
}

maketreelist()
{
	treelist[0]=$treetarget
	opened[0]=1

	lsresult=`ls -X1 $treetarget`

	declare -i j=1
	for s in $lsresult
	do
		s=${treetarget}"/"$s
		treelist=(${treelist[@]} $s)
		opened[${j}]=0
		i=${j}+1
	done
	unset j
	
	depth=0
	for (( i=0; i < ${#treetarget}; i++ ))
	do
		if [ ${treetarget:$i:1} == "/" ]; then
			depth=`expr ${depth} + 1`
		fi
	done
	unset lsresult
}

listload()
{
	if [ $mode = 0 ] || [ $mode = 1 ]; then
		declare -i index=2
	
		hasTrashBin=0
		for s in ${filelist[@]}
		do
			if [[ ${#s} -gt 30 ]]; then
				filename=${s:0:27}...
			else
				filename=$s
			fi
			tput cup $index 1
	
			if [ "${filename}" == "2013726048-TrashBin" ]; then
				echo [33m$filename
				hasTrashBin=1
			elif [ "`file -b ${s}`" == "directory" ]; then
				echo [34m$filename
				dir_num=$dir_num+1
			else
				fileper=`stat -c %A $s`
				if [ ${fileper:3:1} == "x" ]; then
	      				echo [32m$filename
	      				spe_num=$spe_num+1
	      			elif [ "${s##*.}" == "zip" ] || [ "${s##*.}" == "gz" ]; then
	            			echo [31m$filename
	      				spe_num=$spe_num+1
	      			else
	      				echo [0m$filename
	      				nor_num=$nor_num+1
	      			fi
				unset fileper
			fi
			index=${index}+1
			unset filename
		done
		unset index
	elif [ $mode = 2 ]; then
		declare -i index=2
	
		for s in ${bin[@]}
		do
			ss=${s##/*/}
			if [[ ${#ss} -gt 30 ]]; then
				filename=${ss:0:27}...
			else
				filename=${ss}
			fi
			tput cup $index 1

			if [ "`file -b ${s}`" == "directory" ]; then
				echo [34m$filename
				dir_num=$dir_num+1
			else
				fileper=`stat -c %A $s`
				if [ ${fileper:3:1} == "x" ]; then
	      				echo [32m$filename
	      				spe_num=$spe_num+1
	      			elif [ "${s##*.}" == "zip" ] || [ "${s##*.}" == "gz" ]; then
	            			echo [31m$filename
	      				spe_num=$spe_num+1
	      			else
	      				echo [0m$filename
	      				nor_num=$nor_num+1
	      			fi
				unset fileper
			fi
			index=${index}+1
			unset filename
		done
		unset index
	fi
}

treeload()
{
	declare -i index=2

	for s in ${treelist[@]}
	do
		declare -i dep=0
		for (( i=0; i < ${#s}; i++ ))
		do
			if [ ${s:$i:1} == "/" ]; then
				dep=${dep}+1
			fi
		done
		tput cup $index 89
		filename=${s##/*/}
		if [ ${#filename} -gt 30 ]; then
			filename=${filename:0:27}"..."
		fi
		if [ $dep == $depth ]; then
			echo [0m"-"[34m$filename
		elif [ `expr ${dep} - ${depth}` == 1 ]; then
			if [ "`file -b ${s}`" == "directory" ]; then
				echo [0m"-- +"[34m$filename
			else
				fileper=`stat -c %A $s`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"--  "[32m$filename
				elif [ "${s##*.}" == "zip" ] || [ "${s##*.}" == "gz" ]; then
					echo [0m"--  "[31m$filename
				else
					echo [0m"--  "$filename
				fi
			unset fileper
			fi
		elif [ `expr ${dep} - ${depth}` == 2 ]; then
			if [ "`file -b ${s}`" == "directory" ]; then
				echo [0m"---- +"[34m$filename
			else
				fileper=`stat -c %A $s`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"----  "[32m$filename
				elif [ "${s##*.}" == "zip" ] || [ "${s##*.}" == "gz" ]; then
					echo [0m"----  "[31m$filename
				else
					echo [0m"----  "$filename
				fi
			unset fileper
			fi
		elif [ `expr ${dep} - ${depth}` == 3 ]; then
			if [ "`file -b ${s}`" == "directory" ]; then
				echo [0m"------ +"[34m$filename
			else
				fileper=`stat -c %A $s`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"------  "[32m$filename
				elif [ "${s##*.}" == "zip" ] || [ "${s##*.}" == "gz" ]; then
					echo [0m"------  "[31m$filename
				else
					echo [0m"------  "$filename
				fi
			unset fileper
			fi
		elif [ `expr ${dep} - ${depth}` == 4 ]; then
			if [ "`file -b ${s}`" == "directory" ]; then
				echo [0m"-------- +"[34m$filename
			else
				fileper=`stat -c %A $s`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"--------  "[32m$filename
				elif [ "${s##*.}" == "zip" ] || [ "${s##*.}" == "gz" ]; then
					echo [0m"--------  "[31m$filename
				else
					echo [0m"--------  "$filename
				fi
			unset fileper
			fi
		elif [ `expr ${dep} - ${depth}` == 5 ]; then
			if [ "`file -b ${s}`" == "directory" ]; then
				echo [0m"---------- +"[34m$filename
			else
				fileper=`stat -c %A $s`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"----------  "[32m$filename
				elif [ "${s##*.}" == "zip" ] || [ "${s##*.}" == "gz" ]; then
					echo [0m"--------  "[31m$filename
				else
					echo [0m"----------  "$filename
				fi
			unset fileper
			fi
		elif [ `expr ${dep} - ${depth}` == 6 ]; then
			if [ "`file -b ${s}`" == "directory" ]; then
				echo [0m"------------ +"[34m$filename
			else
				fileper=`stat -c %A $s`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"------------  "[32m$filename
				elif [ "${s##*.}" == "zip" ] || [ "${s##*.}" == "gz" ]; then
					echo [0m"------------  "[31m$filename
				else
					echo [0m"------------  "$filename
				fi
			unset fileper
			fi
		elif [ `expr ${dep} - ${depth}` == 7 ]; then
			if [ "`file -b ${s}`" == "directory" ]; then
				echo [0m"-------------- +"[34m$filename
			else
				fileper=`stat -c %A $s`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"--------------  "[32m$filename
				elif [ "${s##*.}" == "zip" ] || [ "${s##*.}" == "gz" ]; then
					echo [0m"--------------  "[31m$filename
				else
					echo [0m"--------------  "$filename
				fi
			unset fileper
			fi
		fi
		index=${index}+1
		unset filename
	done
	unset index
}

cursorload()
{
	echo [0m

	if [ ${mode} == 0 ]; then
		if [[ ${#filelist[${cursor}-2]} -gt 30 ]]; then
   			filename=${filelist[${cursor}-2]:0:27}...
		else
   			filename=${filelist[${cursor}-2]}
		fi
		tput cup $cursor 1
	
		if [ "${filelist[${cursor}-2]}" == "2013726048-TrashBin" ]; then
			echo [43m${filename}
		elif [ "`file -b ${filelist[${cursor}-2]}`" == "directory" ]; then
			echo [44m${filename}
		else
			fileper=`stat -c %A ${filelist[${cursor}-2]}`
			if [ ${fileper:3:1} == "x" ]; then
				echo [42m${filename}
			elif [ "${filelist[${cursor}-2]##*.}" == "zip" ] || [ "${filelist[${cursor}-2]##*.}" == "gz" ]; then
        		echo [41m${filename}
        	else
        		echo [7m${filename}
        	fi
			unset fileper
		fi
		unset filename
	elif [ ${mode} == 1 ]; then
		declare -i dep=0
		for (( i=0; i < ${#treelist[${treecursor}-2]}; i++ ))
		do
			if [ ${treelist[${treecursor}-2]:$i:1} == "/" ]; then
				dep=${dep}+1
			fi
		done
		tput cup $treecursor 89

		treename=${treelist[${treecursor}-2]##/*/}
		if [ ${#treename} -gt 30 ]; then
			treename=${treename:0:27}"..."
		fi
		if [ $dep == $depth ]; then
			echo [0m"-"[44m$treename
		elif [ `expr ${dep} - ${depth}` == 1 ]; then
			if [ "`file -b ${treelist[${treecursor}-2]}`" == "directory" ]; then
				echo [0m"-- +"[44m${treename}
			else
				fileper=`stat -c %A ${treelist[${treecursor}-2]}`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"--  "[42m$treename
				elif [ "${treelist[${treecursor}-2]##*.}" == "zip" ] || [ "${treelist[${treecursor}-2]##*.}" == "gz" ]; then
					echo [0m"--  "[41m$treename
				else
					echo [0m"--  "[7m$treename
				fi
			unset fileper
			fi
		elif [ `expr ${dep} - ${depth}` == 2 ]; then
			if [ "`file -b ${treelist[${treecursor}-2]}`" == "directory" ]; then
				echo [0m"---- +"[44m${treename}
			else
				fileper=`stat -c %A ${treelist[${treecursor}-2]}`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"----  "[42m$treename
				elif [ "${treelist[${treecursor}-2]##*.}" == "zip" ] || [ "${treelist[${treecursor}-2]##*.}" == "gz" ]; then
					echo [0m"----  "[41m$treename
				else
					echo [0m"----  "[7m$treename
				fi
			unset fileper
			fi
		elif [ `expr ${dep} - ${depth}` == 3 ]; then
			if [ "`file -b ${treelist[${treecursor}-2]}`" == "directory" ]; then
				echo [0m"------ +"[44m${treename}
			else
				fileper=`stat -c %A ${treelist[${treecursor}-2]}`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"------  "[42m$treename
				elif [ "${treelist[${treecursor}-2]##*.}" == "zip" ] || [ "${treelist[${treecursor}-2]##*.}" == "gz" ]; then
					echo [0m"------  "[41m$treename
				else
					echo [0m"------  "[7m$treename
				fi
			unset fileper
			fi
		elif [ `expr ${dep} - ${depth}` == 4 ]; then
			if [ "`file -b ${treelist[${treecursor}-2]}`" == "directory" ]; then
				echo [0m"-------- +"[44m${treename}
			else
				fileper=`stat -c %A ${treelist[${treecursor}-2]}`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"--------  "[42m$treename
				elif [ "${treelist[${treecursor}-2]##*.}" == "zip" ] || [ "${treelist[${treecursor}-2]##*.}" == "gz" ]; then
					echo [0m"--------  "[41m$treename
				else
					echo [0m"--------  "[7m$treename
				fi
			unset fileper
			fi
		elif [ `expr ${dep} - ${depth}` == 5 ]; then
			if [ "`file -b ${treelist[${treecursor}-2]}`" == "directory" ]; then
				echo [0m"---------- +"[44m${treename}
			else
				fileper=`stat -c %A ${treelist[${treecursor}-2]}`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"----------  "[42m$treename
				elif [ "${treelist[${treecursor}-2]##*.}" == "zip" ] || [ "${treelist[${treecursor}-2]##*.}" == "gz" ]; then
					echo [0m"----------  "[41m$treename
				else
					echo [0m"----------  "[7m$treename
				fi
			unset fileper
			fi
		elif [ `expr ${dep} - ${depth}` == 6 ]; then
			if [ "`file -b ${treelist[${treecursor}-2]}`" == "directory" ]; then
				echo [0m"------------ +"[44m${treename}
			else
				fileper=`stat -c %A ${treelist[${treecursor}-2]}`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"------------  "[42m$treename
				elif [ "${treelist[${treecursor}-2]##*.}" == "zip" ] || [ "${treelist[${treecursor}-2]##*.}" == "gz" ]; then
					echo [0m"------------  "[41m$treename
				else
					echo [0m"------------  "[7m$treename
				fi
			unset fileper
			fi
		elif [ `expr ${dep} - ${depth}` == 7 ]; then
			if [ "`file -b ${treelist[${treecursor}-2]}`" == "directory" ]; then
				echo [0m"-------------- +"[44m${treename}
			else
				fileper=`stat -c %A ${treelist[${treecursor}-2]}`
				if [ ${fileper:3:1} == "x" ]; then
					echo [0m"--------------  "[42m$treename
				elif [ "${treelist[${treecursor}-2]##*.}" == "zip" ] || [ "${treelist[${treecursor}-2]##*.}" == "gz" ]; then
					echo [0m"--------------  "[41m$treename
				else
					echo [0m"--------------  "[7m$treename
				fi
			unset fileper
			fi
		fi
		index=${index}+1
		unset filename
	elif [ ${mode} == 2 ]; then
		if [[ ${#bin[${cursor}-2]} -gt 30 ]]; then
   			filename=${bin[${cursor}-2]:0:27}...
		else
   			filename=${bin[${cursor}-2]}
		fi
		tput cup $cursor 1

		if [ "`file -b ${bin[${cursor}-2]}`" == "directory" ]; then
			echo [44m${filename}
		else
			fileper=`stat -c %A ${bin[${cursor}-2]}`
			if [ ${fileper:3:1} == "x" ]; then
				echo [42m${filename}
			elif [ "${bin[${cursor}-2]##*.}" == "zip" ] || [ "${bin[${cursor}-2]##*.}" == "gz" ]; then
        			echo [41m${filename}
        		else
        			echo [7m${filename}
        	fi
			unset fileper
		fi
		unset filename
	fi
}

fileload()
{
	if [[ $loadfile != "" ]]; then
		declare -i line_num=1
		declare -i point=2
		while read line
	    do
		if [ $line_num -le 28 ]; then
			tput cup $point 32
			if  [[ ${#line} -gt 53 ]]; then
				if [ $line_num -lt 10 ]; then
					echo [0m0$line_num ${line:0:53}
				else
					echo [0m$line_num ${line:0:53}
				fi
			else
				if [ $line_num -lt 10 ]; then
					echo [0m0$line_num $line
				else
					echo [0m$line_num $line
				fi
			fi
		    line_num=${line_num}+1
			point=${point}+1
		fi
	    done < $loadfile
	    unset line_num
		unset point
	fi
}


infomationload()
{
	file=${filelist[${cursor}-2]}
	tput cup 31 1
	echo [0m"File name : "$file
	tput cup 32 1

	if [ "${file}" == "2013726048-TrashBin" ]; then
		echo [33m"File tye : TrashBin"
	elif [ "`file -b ${file}`" == "directory" ]; then
    	echo [34m"File type : directory"
	else
		fileper=`stat -c %A ${file}`
		if [ ${fileper:3:1} == "x" ]; then
			echo [32m"File type : execute file"
		elif [ "${file##*.}" == "zip" ] || [ "${file##*.}" == "gz" ]; then
			echo [31m"File type : compressed file"
		else
			echo [0m"File type : regular file"
		fi
	fi
	tput cup 33 1
	filesize=`stat -c %s $file`
	if [ $filesize -gt 10000 ]; then
		filesize=`expr $filesize / 1000`" KB"
	elif [ $filesize -gt 10000000 ]; then
		filesize=`expr $filesize / 1000000`" MB"
	elif [ $filesize -gt 10000000000 ]; then
		filesize=`expr $filesize / 1000000000`" GB"
	else
		filesize=${filesize}" B"
	fi
	echo [0m"File size : "$filesize
	unset filesize
	tput cup 34 1
	time=`stat -c %x $file`
	m=${time:5:2}
	if [ $m == "01" ]; then
		month="Jan"
	elif [ $m == "02" ]; then
		month="Feb"
	elif [ $m == "03" ]; then
		month="Mar"
	elif [ $m == "04" ]; then
		month="Apr"
	elif [ $m == "05" ]; then
		month="May"
	elif [ $m == "06" ]; then
		month="Jun"
	elif [ $m == "07" ]; then
		month="Jul"
	elif [ $m == "08" ]; then
		month="Aug"
	elif [ $m == "09" ]; then
		month="Sep"
	elif [ $m == "10" ]; then
		month="Oct"
	elif [ $m == "11" ]; then
		month="Nov"
	elif [ $m == "12" ]; then
		month="Dec"
	fi
	unset m
	echo "Creation time : "$month ${time:8:2} ${time:11:8} ${time:0:4}
	tput cup 35 1
	echo "Permission : "`stat -c %a $file`
	tput cup 36 1
	echo "Absolute path : "`pwd`"/"$file
	unset file
	unset time
}

numload()
{
	size=`du -s . | cut -f1`
	tput cup 38 25

	if [ ${hasTrashBin} == 1 ]; then
		total_n=`expr ${total_num} - 1`
	else
		total_n=${total_num}
	fi
	echo [0m${total_n}" total  "$dir_num" dir  "$nor_num" file  "$spe_num" sfile  "$size" byte"

	unset total_n
}

screenload()
{
	clear
	echo "================================================ 2013726048 JaeWon Kim  ================================================"
	echo "========================================================= List ========================================================="

	for((i=0;i<28;i++))
	do
		echo "|                              |                                                        |                              |"
	done

	echo "====================================================== Infomation ======================================================"

	for((i=0;i<6;i++))
	do
		echo "|                                                                                                                      |"
	done
	
	echo "========================================================= Total ========================================================"
	echo "|                                                                                                                      |"
	echo "========================================================== End ========================================================="
	
	makelist
	listload
	if [ $mode == 1 ]; then
		treeload
	fi
	cursorload
	fileload
	infomationload
	numload
	tput cup 40 1
	echo [0m
}

cd ~
mkdir 2013726048-TrashBin
while [ true ]; do
	screenload
	read -n 1 key
	if [ $mode == 0 ]; then
		if [ $key ==  ]; then
			read -n 1 key
			if [ $key == "[" ]; then
				read -n 1 key
				if [ $key == "A" ]; then
					if [ $cursor -gt 2 ]; then
						cursor=${cursor}-1
						unset loadfile
					fi
				elif [ $key == "B" ]; then
					unset max
					declare -i max=${total_num}+2
					if [ $cursor -lt $max ]; then
						cursor=${cursor}+1
						unset loadfile
					fi
				fi
			fi
		elif [[ $key = "" ]]; then
			if [ "${filelist[${cursor}-2]}" == "2013726048-TrashBin" ]; then
				cd ${filelist[${cursor}-2]}
				mode=2
			elif [ "`file -b ${filelist[${cursor}-2]}`" == "directory" ]; then
				cd ${filelist[${cursor}-2]}
				cursor=2
				unset loadfile
			elif [ "${filelist[${cursor}-2]##*.}" != "zip" ] && [ "${filelist[${cursor}-2]##*.}" != "gz" ]; then
				loadfile=${filelist[${cursor}-2]}
			fi
		elif [ $key == "t" ]; then
			if [ "`file -b ${filelist[${cursor}-2]}`" == "directory" ]; then
				mode=1
				treetarget=`pwd`/${filelist[${cursor}-2]}
				treemax=`ls $treetarget | wc -l`
				treemax=${treemax}+2
				treecursor=2
				unset treelist
				maketreelist
			fi
		elif [ $key == "d" ]; then
			temp=`pwd`${filelist[${cursor}-2]}
			bin=(${bin[@]} $temp)
		fi
	elif [ $mode == 1 ]; then
		if [ $key ==  ]; then
			read -n 1 key
			if [ $key == "[" ]; then
				read -n 1 key
				if [ $key == "A" ]; then
					if [ $treecursor -gt 2 ]; then
						treecursor=${treecursor}-1
					fi
				elif [ $key == "B" ]; then
					if [ $treecursor -lt $treemax ]; then
						treecursor=${treecursor}+1
						tttt=$treemax
					fi
				fi
			fi
		elif [[ $key = "" ]]; then
			if [ "`file -b ${treelist[${treecursor}-2]}`" == "directory" ]; then
				if [ ${opened[${treecursor}-2]} == "0" ]; then
					declare -i tree_num=${#treelist[@]}-1
					declare -i n=`ls ${treelist[${treecursor}-2]} | wc -l`
					ls=`ls -X1 ${treelist[${treecursor}-2]}`

					for ((i=0; i < n+1; i++))
					do
						declare -i t=`expr ${tree_num} + $n`
						t=`expr $t - $i`
						declare -i te=`expr ${tree_num} - $i`
						treelist[$t]=${treelist[${te}]}
						opened[$t]=${opened[${te}]}
					done
					unset t
					unset te

					declare -i m=${treecursor}-1
					for s in $ls
					do
						t=${treelist[${treecursor}-2]}"/"$s
						treelist[$m]=$t
						opened[$m]=0
						m=${m}+1
					done
					unset ls
					opened[${treecursor}-2]=1
					treemax=${#treelist[@]}+1
				fi
			fi
		elif [ $key == "r" ]; then
			mode=0
			unset treelist
		fi
	elif [ $mode == 2 ]; then
		if [ $key ==  ]; then
			read -n 1 key
			if [ $key == "[" ]; then
				read -n 1 key
				if [ $key == "A" ]; then
					if [ $cursor -gt 2 ]; then
						cursor=${cursor}-1
						unset loadfile
					fi
				elif [ $key == "B" ]; then
					unset max
					declare -i max=${total_num}+2
					if [ $cursor -lt $max ]; then
						cursor=${cursor}+1
						unset loadfile
					fi
				fi
			fi
		elif [[ $key = "" ]]; then
			if [ "${bin[${cursor}-2]}" == ".." ]; then
				cd ~
				mode=0
			elif [ "`file -b ${bin[${cursor}-2]}`" == "directory" ]; then
				cd ${bin[${cursor}-2]}
				cursor=2
				unset loadfile
			elif [ "${bin[${cursor}-2]##*.}" != "zip" ] && [ "${bin[${cursor}-2]##*.}" != "gz" ]; then
				loadfile=${bin[${cursor}-2]}
			fi
		fi
	fi
done			
