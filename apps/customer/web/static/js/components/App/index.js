import React, { PropTypes, Component } from 'react';
import styles from './styles.css';
const propTypes = {
  children: PropTypes.object.isRequired
};

class App extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className={styles.root}>
        <main id="content" className={styles.main}>
          {this.props.children}
        </main>
      </div>
    );
  }
};

App.propTypes = propTypes;

export default App;
