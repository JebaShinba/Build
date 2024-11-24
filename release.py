import requests
import os
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")


# Repository details
OWNER = "JebaShinba"  # e.g., "octocat"
REPO = "Build"  # e.g., "Hello-World"

# Function to get the latest release
def get_latest_release(owner, repo):
    url = f"https://api.github.com/repos/{owner}/{repo}/releases/latest"
    headers = {"Authorization": f"token {GITHUB_TOKEN}"}
    
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        raise Exception(f"Failed to fetch release: {response.status_code} {response.text}")

# Function to download an asset
def download_asset(asset_url, save_path):
    headers = {
        "Authorization": f"token {GITHUB_TOKEN}",
        "Accept": "application/octet-stream"
    }
    response = requests.get(asset_url, headers=headers, stream=True)
    response.raise_for_status()
    
    with open(save_path, "wb") as file:
        for chunk in response.iter_content(chunk_size=1024):
            file.write(chunk)
    print(f"Downloaded: {save_path}")

# Main script
try:
    latest_release = get_latest_release(OWNER, REPO)
    print(f"Latest Release: {latest_release['name']}")

    assets = latest_release.get("assets", [])
    if not assets:
        print("No assets found in the latest release.")
    else:
        download_folder = "github_downloads"
        os.makedirs(download_folder, exist_ok=True)

        for asset in assets:
            asset_name = asset["name"]
            asset_url = asset["url"]
            save_path = os.path.join(download_folder, asset_name)
            download_asset(asset_url, save_path)
except Exception as e:
    print(f"Error: {e}")
