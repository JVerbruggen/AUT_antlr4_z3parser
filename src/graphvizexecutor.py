import subprocess

class GraphVizExecutor:
    def run(self, filename:str):
        filename_noextension = filename
        if "." in filename: filename_noextension = filename.split(".")[0]

        subprocess.Popen(["dot.exe", "-Tpng", f"-o{filename_noextension}.png", f"{filename}"])