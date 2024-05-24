import cv2
import mediapipe as mp

mp_holistic = mp.solutions.holistic
mp_drawing = mp.solutions.drawing_utils
mp.drawing_styles = mp.solutions.drawing_styles

def finger_count():
    cap = cv2.VideoCapture(0)

    # Initialized holistic model
    holistic = mp_holistic.Holistic(min_detection_confidence=0.5, min_tracking_confidence=0.5)

    while cap.isOpened():
        status, frame = cap.read()

        if not status:
            break

        # Transform frame
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        # Inference
        results = holistic.process(rgb_frame)

        # Left hand
        mp_drawing.draw_landmarks(frame, results.left_hand_landmarks, mp_holistic.HAND_CONNECTIONS)

        # Right hand
        mp_drawing.draw_landmarks(frame, results.right_hand_landmarks, mp_holistic.HAND_CONNECTIONS)

        if results.right_hand_landmarks:
            hand_landmark = results.right_hand_landmarks.landmark
            write_position(hand_landmark[9])
        
        # Display
        cv2.imshow("frame", frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()

def write_position(position):
    x, y, z = position.x, position.y, position.z

    cord = str(round(x, 3) * 2) + "," + str(round(y, 3) * 2) + "," + str(round(z, 3))

    with open("coordenadas.txt", "w") as file:
        print(cord)
        file.write(cord)

if __name__ == '__main__':
    finger_count()
