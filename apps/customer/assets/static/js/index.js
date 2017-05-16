import React from 'react';
import { render } from 'react-dom';
import routes from './routes';
import 'sanitize.css/sanitize.css';
// import '../vendor/styles/bootstrap.css';
// Import CSS reset and Global Styles
import './styles/global-styles';


render(routes, document.getElementById('app'));
