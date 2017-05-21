import styled from 'styled-components';
import colors from 'styles/colors';

export const Wrapper = styled.section`
  margin-top: 30px;
`;

export const Header = styled.li`
  display: flex;
  width: 100%;
  padding-bottom: 10px;
  list-style: none;
  border-bottom: 1px solid ${colors.listBorderColor};
  
`;

export const HeaderRow = styled.div`
  width: ${props => props.size}0%;
  color: #B3B3B3;
  font-weight: bold;
`;

export const ContentWrapper = styled.div`
  
`;
