import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Helmet from 'react-helmet';
import { Footer } from 'components';
import { HeaderContainer } from 'containers';
import Wrapper from './styles';
import config from '../../config';

class App extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        <Helmet
          titleTemplate={`%s | ${config.siteName}`}
          title={config.siteName}
          meta={[
            { name: 'description', content: 'place to find startup jobs' },
          ]}
        />
        <HeaderContainer />
        <Wrapper>
          {this.props.children}
        </Wrapper>
        <Footer />
      </div>
    );
  }
}
const propTypes = {
  children: PropTypes.node.isRequired,
};


App.propTypes = propTypes;

export default App;
