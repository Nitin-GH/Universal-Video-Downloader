import tkinter as tk
from tkinter import messagebox, ttk
import subprocess
import os

def download_video():
    url = url_entry.get()
    quality = quality_choice.get()

    if not url:
        messagebox.showerror("Error", "Please enter a URL")
        return

    download_path = os.path.join(os.getcwd(), 'Downloaded_Videos')
    if not os.path.exists(download_path):
        os.makedirs(download_path)

    # Assuming you have your downloader as a command line tool
    command = ['yt-dlp', '-f', quality, '-o', os.path.join(download_path, '%(title)s.%(ext)s'), url]

    # Run the download command
    try:
        subprocess.run(command, check=True)
        messagebox.showinfo("Success", f"Downloaded video to {download_path}")
    except subprocess.CalledProcessError as e:
        messagebox.showerror("Error", f"Failed to download video: {str(e)}")

# GUI Setup
app = tk.Tk()
app.title("Video Downloader Showcase")
app.geometry("400x300")

tk.Label(app, text="Enter Video URL:").pack(pady=10)
url_entry = tk.Entry(app, width=50)
url_entry.pack(pady=5)

tk.Label(app, text="Select Video Quality:").pack(pady=10)
quality_choice = ttk.Combobox(app, values=["360p", "480p", "720p", "1080p", "1440p", "4K"], state="readonly")
quality_choice.set("720p")  # Default value
quality_choice.pack(pady=5)

download_button = tk.Button(app, text="Download Video", command=download_video)
download_button.pack(pady=20)

app.mainloop()
