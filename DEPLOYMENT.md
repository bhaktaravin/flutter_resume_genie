# Deployment Guide - GitHub Pages

## 🌐 Deploy to GitHub Pages

Your Flutter app is configured to deploy automatically to GitHub Pages!

### Setup Steps:

1. **Push your code to GitHub** (if not already done):
   ```bash
   git add .
   git commit -m "Add GitHub Pages deployment"
   git push origin main
   ```

2. **Enable GitHub Pages**:
   - Go to your repository: `https://github.com/bhaktaravin/flutter_resume_genie`
   - Navigate to **Settings** → **Pages**
   - Under **Source**, select **GitHub Actions**

3. **Trigger the deployment**:
   - The workflow will run automatically on push to `main`
   - Or manually trigger it from the **Actions** tab

4. **Access your deployed app**:
   - Your app will be available at: `https://bhaktaravin.github.io/flutter_resume_genie/`
   - Usually takes 2-5 minutes for first deployment

### 🔧 Environment Variables

**Important:** Your Groq API key should be added as a GitHub secret for the deployed app to work with AI features:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Name: `GROQ_API_KEY`
4. Value: Your Groq API key

Then update the workflow to inject it during build (or handle it client-side with user input).

### 📝 Notes:

- The app builds with `--base-href "/flutter_resume_genie/"` to work with GitHub Pages subdirectory
- `.nojekyll` file ensures proper asset loading
- Web builds are optimized for production with `--release` flag
- The workflow uses Flutter stable channel (3.24.0)

### 🔄 Updates:

Every time you push to `main`, your site will automatically rebuild and redeploy!

### 🐛 Troubleshooting:

- **Build fails**: Check the Actions tab for error logs
- **404 errors**: Ensure Pages is set to "GitHub Actions" source
- **Assets not loading**: Verify `.nojekyll` file exists in web folder
- **API features not working**: Add your API key as a repository secret or implement client-side key input
