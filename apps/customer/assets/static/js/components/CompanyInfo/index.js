import React from 'react';
import PropTypes from 'prop-types';
import { Wrapper, Item } from './styles';
import MdLocationCity from 'react-icons/lib/md/location-city';
import MdLocationOn from 'react-icons/lib/md/location-on';
import colors from 'styles/colors';


const propTypes = {
  name: PropTypes.string.isRequired,
  area: PropTypes.string.isRequired,
};

const iconStyle = {
  color: colors.leadSentenceColor,
  marginRight: 5,
};

const CompanyInfo = ({ name, area }) => (
  <Wrapper>
    <Item>
      <MdLocationCity style={iconStyle} />
      <span>{name}</span>
    </Item>
    <Item>
      <MdLocationOn style={iconStyle} />
      <span>{area}</span>
    </Item>
  </Wrapper>
  );


CompanyInfo.propTypes = propTypes;
export default CompanyInfo;
