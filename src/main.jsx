import React from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import App from './App.jsx';
import './styles.css';

class AppErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }
  static getDerivedStateFromError() {
    return { hasError: true };
  }
  componentDidCatch(error, info) {
    console.error('Portfolio render error:', error, info);
  }
  render() {
    if (this.state.hasError) {
      return <main className="app-error" role="alert">
        <span className="eyebrow">A TEMPORARY INTERRUPTION</span>
        <h1>That frame<br/><em>didn't load.</em></h1>
        <p>The page hit an unexpected error. Reload to try again.</p>
        <button className="primary-btn" onClick={() => window.location.reload()}>RELOAD PAGE ↗</button>
      </main>;
    }
    return this.props.children;
  }
}

createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <BrowserRouter>
      <AppErrorBoundary><App /></AppErrorBoundary>
    </BrowserRouter>
  </React.StrictMode>
);
