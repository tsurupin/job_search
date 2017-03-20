import { injectGlobal } from 'styled-components';
injectGlobal`
  html {
    font-size: 62.5%;
    min-height: 1000px;
  }
  
  body {
    font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  }
   
  a {
    text-decoration: none;
    color: black;
  }
  
  button {
    margin: 0;
    padding: 0;
    background: none;
    border: none;
    border-radius: 0;
    outline: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
  }
  
  input {
     margin: 0;
    padding: 0;
    background: none;
    border: none;
    border-radius: 0;
    outline: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
  }
  
  input[type="button"] {
    border-radius: 0;
    -webkit-box-sizing: content-box;
    -webkit-appearance: button;
    appearance: button;
    border: none;
    box-sizing: border-box;
    &::-webkit-search-decoration {
      display: none;
    }
    &::focus {
      outline-offset: -2px;
    }
  }
  
  select {
    margin: 0;
    padding: 0;
    background: none;
    border: none;
    border-radius: 0;
    outline: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
  }
`;