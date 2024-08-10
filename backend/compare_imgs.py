with open("backend/message_5.txt", 'r') as file:
        working_v = file.read()

with open("image_encoded.txt", 'r') as file:
        failing_v = file.read()


print(failing_v == working_v)

