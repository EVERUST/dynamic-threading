import subprocess
import os

def create_scenario(sleep_scenario, active_sleeps):
	ret_scenario = [];
	for i in range(0, len(active_sleeps)):
		if active_sleeps[i] == 0:
			off_sleep = sleep_scenario[i].split('-')
			off_sleep[1] = '0'
			ret_scenario.append('-'.join(off_sleep))
		else:
			ret_scenario.append(sleep_scenario[i])
	return ret_scenario

def amplify_sleep_at(sleep_scenario, amplify_target_ind):
	


def main():
	err_command = input("input exe command: ");
	print(err_command)

	fp = open(r"sleep_record", 'r')
	line = fp.readline()
	fp.close()
	sleep_scenario = line.split('+')
	sleep_scenario.remove('')

	# 0 being off, 1 being on
	active_sleeps = [1] * len(sleep_scenario)

	try_off_ind = 0
	sleep_record = open("sleep_record", "w")
	for try_off_ind in range(0, len(sleep_scenario)):
		new_scenario = create_scenario(sleep_scenario, active_sleeps)
		sleep_record.seek(0)
		sleep_record.truncate()
		sleep_record.write('+'.join(new_scenario))

		process = subprocess.Popen(err_command.split(' '), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		stdout, stderr = process.communicate()
		if try_off_ind % 100 == 0:
			print(str(try_off_ind) + " " + str(process.returncode))
		if process.returncode != 0:
			active_sleeps[try_off_ind] = 0
		else:
			amplify_sleep_at(try_off_ind)

	print(active_sleeps)
	new_scenario = create_scenario(sleep_scenario, active_sleeps)
	sleep_record = open("sleep_record", "w")
	sleep_record.truncate()
	sleep_record.write('+'.join(new_scenario))
	sleep_record.close()
	

if __name__ == '__main__':
	main()
