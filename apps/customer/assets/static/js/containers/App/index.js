import React, { PropTypes, Component } from 'react';
import Helmet from 'react-helmet';
import  { Footer } from 'components';
import { HeaderContainer } from 'containers';
import Wrapper from './Wrapper';

class App extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        <Helmet
          titleTemplate="%s - Startup Job"
          defaultTitle="Index"
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
};

const propTypes = {
  children: PropTypes.node.isRequired
};


App.propTypes = propTypes;

export default App;
